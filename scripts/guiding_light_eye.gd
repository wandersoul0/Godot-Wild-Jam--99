extends AnimatedSprite2D

@onready var TFO = $".."
@export var follow_speed: float = 5.0
@export var look_distance: float = 5.05
var start_pos
var lookReady: = false

func _ready():
	global.death.connect(death)
	start_pos = TFO.global_position
	start_pos.y += 1.9

func death():
	global_position = start_pos
	await get_tree().create_timer(2.5).timeout
	lookReady = true

func _process(delta):
	if global.game_active == false and global.dead == true and lookReady == true:
		var mouse_pos = get_global_mouse_position()
		var mouse_dir: Vector2 = TFO.global_position.direction_to(mouse_pos)
		var target_pos = start_pos + (mouse_dir * look_distance)
		global_position = global_position.lerp(target_pos, 1.0 - exp(-follow_speed * delta))
