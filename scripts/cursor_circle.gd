extends AnimatedSprite2D

@export var min_interval: float = 0.9
@export var max_interval: float = 1.5
@export var slam_force: float = 650.0
@export var slamSpeed = 0.12
@export var endlessDifficultyCurve = 4
@onready var centerCircle = $"../centerCircle"
@onready var timer = $slamTimer
@onready var roundTimer = $roundTimer
@onready var music_player1 = get_node_or_null("/root/main/mainMenu/sound/mainRoundMusic")
@export_range(0.0, 1.0) var usurper_chance = 0.1
@export_range(0.0, 1.0) var deciever_chance = 0.1

var slam_enabled = true
var is_warping = false
var is_slamming = false
var default_scale
var scale_mult = 0.0
var current_max_interval
var current_min_interval
var current_slam_force


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	global.begin.connect(begin)
	global.reset.connect(resetGame)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	timer.timeout.connect(on_slam_timer_timeout)
	timer.start(randf_range(min_interval, max_interval))
	default_scale = scale
	roundTimer.timeout.connect(endGame)
	roundTimer.wait_time = global.baseRoundTime
	hide()
	
func toggle_pause() -> void:
	global.pause_toggle = !global.pause_toggle
	music_player1.stream_paused = !music_player1.stream_paused
	
	if global.pause_toggle == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0
		is_warping = true
		var screen_pos: Vector2 = get_viewport().get_canvas_transform() * global_position
		get_viewport().warp_mouse(screen_pos)
		await get_tree().process_frame
		is_warping = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func resetGame() -> void:
	scale_mult = 0.0
	begin()
	
func begin():
	get_viewport().gui_disable_input = false
	roundTimer.stop()
	if global.gamemode == 1:
		roundTimer.wait_time = global.baseRoundTime
		global.roundTime = global.baseRoundTime
		roundTimer.one_shot = true
	elif global.gamemode == 2:
		global.difficulty = 500
		roundTimer.wait_time = 1
		global.roundTime = 0
		roundTimer.one_shot = false
	scale_mult = 0.0
	show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale_mult", 1.0, 1.0)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	global.roundReady = true
	roundTimer.start()
	var mult = clamp(global.difficulty, 0.0, 1000.0) / 700.0
	current_slam_force = slam_force * mult
	current_min_interval = min_interval / max(mult, 0.25)
	current_max_interval = max_interval / max(mult, 0.25)

func _process(_delta: float) -> void:
	scale = default_scale * scale_mult
	if Input.is_action_just_pressed("esc") and global.game_active:
		toggle_pause()
	if global.pause_toggle == true or global.game_active == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif not is_warping:
		var mouse_pos = get_global_mouse_position()
		if not is_slamming and mouse_pos.distance_to(global_position) > 250.0:
			get_viewport().warp_mouse(get_viewport().get_canvas_transform() * global_position)
			return
		global_position = mouse_pos
		mouse_pos.x = clamp(mouse_pos.x, 0, get_viewport_rect().size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, get_viewport_rect().size.y)
	if not roundTimer.is_stopped():
		global.roundTime = roundTimer.time_left
			
func endGame() -> void:
	roundTimer.stop()
	if global.gamemode == 1:
		global.roundReady = false
		global.game_active = false
		if global.difficulty > global.difficulty_record:
			global.difficulty_record = global.difficulty
	global.success.emit()

func on_slam_timer_timeout() -> void:
	var min_int = current_min_interval if current_min_interval != null else min_interval
	var max_int = current_max_interval if current_max_interval != null else max_interval
	timer.start(randf_range(min_int, max_int))
	if slam_enabled and global.game_active and global.roundReady:
		var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
		var random_force = (randf() + 0.3) * current_slam_force
		var start_pos: Vector2 = global_position
		var target_pos: Vector2 = start_pos + random_direction * random_force
		is_slamming = true
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_method(
			func(pos: Vector2):
				var viewport_pos: Vector2 = get_viewport().get_canvas_transform() * pos
				get_viewport().warp_mouse(viewport_pos),
				start_pos, target_pos, slamSpeed)
		tween.finished.connect(func(): is_slamming = false)
		var mult = clamp(global.difficulty, 0.0, 1000.0) / 700.0
		current_slam_force = slam_force * mult
		current_min_interval = min_interval / max(mult, 0.25)
		current_max_interval = max_interval / max(mult, 0.25)
		global.score += 1
		if global.gamemode == 2:
			global.difficulty += endlessDifficultyCurve
			var screen_size: Vector2 = get_viewport_rect().size
			var spawn_pos = Vector2(
			randf_range(100, screen_size.x - 100),
			randf_range(100, screen_size.y - 100))
			"if randf() < usurper_chance:
				global.spawn_usurper(spawn_pos)
			else:
				usurper_chance += 0.1"
