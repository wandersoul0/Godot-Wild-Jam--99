extends AnimatedSprite2D
@onready var tryAgainButton = $"../tryAgainButton"
@onready var returnToMainScreenButton = $"../returnToMainScreenButton"
@onready var eye = $guidingLightEye

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)

func death():
	hide()
	eye.lookReady = false
	returnToMainScreenButton.hide()
	tryAgainButton.hide()
	frame = 7
	await get_tree().create_timer(1.5).timeout
	show()
	returnToMainScreenButton.show()
	tryAgainButton.show()
	
func reset():
	pass

func _process(delta: float) -> void:
	pass
