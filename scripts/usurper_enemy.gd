extends AnimatedSprite2D

@export var lifespan: float = 7.5
@export var max_speed: float = 1500.0
@export var accel: float = 500.0
@export var dmg: int = 20
@export var turn_speed: float = 5

var innercircle: Node2D
var spawned = false
var speed = 0.25
var dir: Vector2
var life_left: float = 0.0

func _ready():
	innercircle = get_node_or_null("/root/main/mainGame/cursorCircle")
	global.begin.connect(begin)
	global.reset.connect(reset)
	animation = "nuetral"
	frame = 0
	z_index = 2
	show()


func spawn_usurper():
	spawned = false
	speed = 0.25
	play("Spawn")
	await animation_finished
	if not is_instance_valid(self):
		return
	stop()
	animation = "nuetral"
	frame = 1
	spawned = true
	life_left = lifespan
	dir = global_position.direction_to(innercircle.global_position)

func _physics_process(delta: float) -> void:
	if not spawned or not is_instance_valid(innercircle):
		return
	life_left -= delta
	if life_left <= 0.0:
		death()
		return
	var to_target: Vector2 = innercircle.global_position - global_position
	var dist: float = to_target.length()
	if dist < 55.0:
		global.player_health -= 1000
		death()
		return
	var target_dir: Vector2 = to_target / dist
	if dir.is_zero_approx():
		dir = target_dir
	else:
		dir = dir.normalized()
	var alignment: float = dir.dot(target_dir)
	var speed_ratio: float = clampf(speed / max_speed, 0.0, 1.0)
	if alignment < 0.0:
		speed = move_toward(speed, 0.0, accel * 1.6 * delta)
		if speed < max_speed * 0.12:
			dir = target_dir
		else:
			var angle_diff: float = dir.angle_to(target_dir)
			var max_turn: float = turn_speed * 0.25 * delta
			dir = dir.rotated(clampf(angle_diff, -max_turn, max_turn)).normalized()
	else:
		var effective_turn: float = turn_speed * lerpf(1.4, 0.45, speed_ratio)
		var angle_diff: float = dir.angle_to(target_dir)
		var max_turn: float = effective_turn * delta
		dir = dir.rotated(clampf(angle_diff, -max_turn, max_turn)).normalized()
		speed = move_toward(speed, max_speed, accel * delta)
	global_position += dir * speed * delta

func death():
	frame = 2
	if not spawned:
		return
	spawned = false
	play("Death")
	await animation_finished
	queue_free()

func reset():
	spawned = false
	queue_free()


func begin():
	pass
