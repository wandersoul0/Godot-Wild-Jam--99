extends TextureProgressBar

@export var white_texture: Texture2D
@export var red_texture: Texture2D

var last_health = 100.0
var is_tweening: bool = false

func _ready():
	hide()
	global.reset.connect(reset)
	global.begin.connect(begin)
	
func begin():
	show()
	global.player_health = 100
	last_health = 100.0
	texture_progress = white_texture
	
	value = 0.0
	is_tweening = true
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "value", 100.0, 1.0)
	tween.finished.connect(func(): is_tweening = false)
	
func reset():
	show()
	
func _process(_delta):
	if not is_tweening:
		value = global.player_health

	if global.pause_toggle == false:
		if global.player_health < last_health:
			texture_progress = red_texture
		else:
			texture_progress = white_texture

		last_health = global.player_health
