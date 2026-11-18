extends AnimatedSprite2D

@export var lifespan: float = 7.5
@export var max_speed: float = 400.0
@export var accel: float = 100.0
@export var dmg: int = 20
@export var turn_speed: float = 1.5

var innercircle: Node2D
var spawned = false
var speed = 0.25
var dir: Vector2

func _ready():
	innercircle = get_node_or_null("/root/main/InnerCircle")
	global.begin.connect(begin)
	global.reset.connect(reset)
	
	frame = 0
	z_index = 2
	show()
	_spawn_usurper()

func _spawn_usurper():
	play("Spawn")
	await animation_finished
	spawned = true
	frame = 1
	live()

func live():
	if not spawned or not is_instance_valid(innercircle):
		return
	var life_time = get_tree().create_timer(lifespan)
	dir = global_position.direction_to(innercircle.global_position)
	
	while life_time.time_left > 0 and spawned:
		await get_tree().process_frame
		if not is_instance_valid(self) or not spawned or not is_instance_valid(innercircle):
			return
			
		var delta = get_process_delta_time()
		var target_dir = global_position.direction_to(innercircle.global_position)
		
		dir = dir.move_toward(target_dir, turn_speed * delta)
		speed = clamp(speed + accel * delta, 0.0, max_speed)
		global_position += dir * speed * delta
		
		if global_position.distance_to(innercircle.global_position) < 35.0:
			global.player_health -= dmg
			break
			
	if spawned:
		spawned = false
		death()

func death():
	spawned = false
	play("Death")
	await animation_finished
	queue_free()

func reset():
	queue_free()
	
func begin():
	pass
