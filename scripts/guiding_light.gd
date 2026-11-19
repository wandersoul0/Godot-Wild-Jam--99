extends AnimatedSprite2D
@onready var pressed_sound = get_node("/root/main/mainMenu/sound/buttonClick1")
@onready var tryAgainButton = $"../tryAgainButton"
@onready var returnToMainScreenButton = $"../returnToMainScreenButton"
@onready var eye = $guidingLightEye
@onready var scoreLabel = $"../score"
@onready var difficultyLabel = $"../difficulty"
@onready var winScreen = $"../../winScreen"
var victoryCheck = false

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)
	global.success.connect(win)

func death_sequence():
	hide()
	eye.lookReady = false
	returnToMainScreenButton.hide()
	tryAgainButton.hide()
	scoreLabel.hide()
	difficultyLabel.hide()
	frame = 7
	await get_tree().create_timer(1.1).timeout
	pressed_sound.play()
	show()
	if victoryCheck:
		winScreen.show()
	await get_tree().create_timer(1.3).timeout
	returnToMainScreenButton.show()
	tryAgainButton.show()
	pressed_sound.play()
	if global.gamemode == 2:
		scoreLabel.show()
		difficultyLabel.show()
	await get_tree().create_timer(1.3).timeout
	eye.lookReady = true
	
func win():
	if global.gamemode == 2:
		return
	victoryCheck = true
	death_sequence()

func death():
	victoryCheck = false
	death_sequence()
	
func reset():
	pass

func _process(delta: float) -> void:
	pass
