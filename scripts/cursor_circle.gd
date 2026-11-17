extends AnimatedSprite2D

@export var min_interval: float = 0.7
@export var max_interval: float = 1.3
@export var slam_force: float = 650.0
@onready var timer = $slamTimer
@onready var centerCircle = $"../centerCircle"

var score = 0
var slam_enabled = true
var is_warping: bool = false
var default_scale
var scale_mult = 0.0
var current_max_interval
var current_min_interval
var current_slam_force

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	global.begin.connect(begin)
	global.reset.connect(resetGame)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	timer.timeout.connect(on_slam_timer_timeout)
	timer.start(randf_range(min_interval, max_interval))
	default_scale = scale
	hide()

func toggle_pause() -> void:
	global.pause_toggle = !global.pause_toggle
	get_tree().paused = global.pause_toggle
	
	if global.pause_toggle == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		is_warping = true
		var screen_pos: Vector2 = get_viewport().get_canvas_transform() * global_position
		get_viewport().warp_mouse(screen_pos)
		await get_tree().process_frame
		is_warping = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func resetGame() -> void:
	pass

func reset() -> void:
	pass
	
func begin():
	scale_mult = 0.0
	show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale_mult", 1.0, 2.5)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	global.roundReady = true
	var mult = clamp(global.difficulty, 0.0, 1000.0) / 700.0
	current_slam_force = slam_force * mult
	current_min_interval = min_interval / max(mult, 0.25)
	current_max_interval = max_interval / max(mult, 0.25)

func _process(_delta: float) -> void:
	scale = default_scale * scale_mult
	if Input.is_action_just_pressed("esc"):
		toggle_pause()
	if global.pause_toggle == true or global.game_active == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif not is_warping:
		global_position = get_global_mouse_position()



func on_slam_timer_timeout() -> void:
	if slam_enabled == true and global.game_active == true and global.roundReady == true:
		var distance = global_position.distance_to(centerCircle.global_position)
		var random_direction: Vector2 = Vector2.RIGHT.rotated(randf() * 2.0 * PI)
		var random_force = ((randf() + 0.3) * current_slam_force)
		var target_mouse_pos = position + random_direction.normalized() * random_force
		var wait_time = randf_range(current_min_interval, current_max_interval)
		timer.start(wait_time)
		var tween = create_tween()
		tween.tween_method(
			func(pos): Input.warp_mouse(get_viewport().get_canvas_transform() * pos),
			get_global_mouse_position(),
			target_mouse_pos,
			0.1)
	score += 1
