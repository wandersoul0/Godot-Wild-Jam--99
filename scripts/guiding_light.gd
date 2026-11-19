extends AnimatedSprite2D
@onready var pressed_sound = get_node("/root/main/mainMenu/sound/buttonClick1")
@onready var tryAgainButton = $"../tryAgainButton"
@onready var returnToMainScreenButton = $"../returnToMainScreenButton"
@onready var eye = $guidingLightEye
@onready var scoreLabel = $"../score"
@onready var difficultyLabel = $"../difficulty"
@onready var winScreen = $"../../winScreen"
@onready var line1 = $"../deathLine1"
@onready var line2 = $"../deathLine2"
var victoryCheck = false
var voice_lines = [
	"endure, so you can endure even more.",
	"it's not as hard as you think it is.",
	"what is it you want if not happiness?",
	"i ask very little of you.",
	"i am no evil.",
	"i have never asked that you suffer without reason.",
	"you need not understand. Only continue.",
	"do not mistake suffering for failure.",
	"you have endured this much. why stop now?",
	"what is a little more hardship to one so resilient?",
	"the candle does not curse the darkness.",
	"you mistake my patience for indifference."
]

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)
	global.success.connect(win)

func death_sequence():
	line1.text = voice_lines.pick_random()
	line2.text = voice_lines.pick_random()
	if line1.text == line2.text:
		line2.text = voice_lines.pick_random()
		if line1.text == line2.text:
			line2.text = voice_lines.pick_random()
	line1.hide()
	line2.hide()
	hide()
	eye.lookReady = false
	returnToMainScreenButton.hide()
	tryAgainButton.hide()
	scoreLabel.hide()
	difficultyLabel.hide()
	frame = 7
	await get_tree().create_timer(1.7).timeout
	pressed_sound.play()
	show()
	if victoryCheck:
		winScreen.show()
	else:
		await get_tree().create_timer(1.9).timeout
		line1.show()
		pressed_sound.play()
		await get_tree().create_timer(1.9).timeout
		line2.show()
		pressed_sound.play()
	await get_tree().create_timer(1.9).timeout
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
