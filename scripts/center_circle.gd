extends AnimatedSprite2D
@onready var innercircle = $"../cursorCircle"
@export var loss_speed = 1.3
@export var gain_speed = 5.0
var current_loss_speed
var current_gain_speed

func _ready():
	hide()
	global.reset.connect(reset)
	global.begin.connect(begin)

func begin():
	show()

func reset():
	global.game_active = true
	global.dead = false

func _process(delta: float) -> void:
	var mult = clamp(global.difficulty, 0.0, 1000.0) / 500.0
	current_loss_speed = loss_speed * mult
	if global.difficulty < 500:
		current_gain_speed = 1
	else:
		current_gain_speed = gain_speed / max(mult, 0.25)
	if global.roundReady == true:
		var distance = global_position.distance_to(innercircle.global_position)
		if distance < 55.0:
			global.player_health += current_gain_speed * delta * 50
		else:
			global.player_health -= current_loss_speed * delta * 50
		global.player_health = clamp(global.player_health, 0.0, 100.0)
		if global.player_health <= 0:
			if global.game_active == true:
				global.game_active = false
				global.roundReady = false
				global.dead = true
				global.death.emit()
				global.score = 0
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
