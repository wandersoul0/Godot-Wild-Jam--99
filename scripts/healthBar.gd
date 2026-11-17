extends TextureProgressBar

@export var white_texture: Texture2D
@export var red_texture: Texture2D

var last_health = 100.0

func _ready():
	hide()
	global.reset.connect(reset)
	global.begin.connect(begin)
	
func begin():
	show()
	
func reset():
	global.player_health = 100
	
func _process(_delta):
	value = global.player_health

	if global.pause_toggle == false:
		
		if global.player_health < last_health:
			texture_progress = red_texture
		else:
			texture_progress = white_texture

		last_health = global.player_health
