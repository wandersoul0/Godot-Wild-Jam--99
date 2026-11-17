extends AnimatedSprite2D

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)

func death():
	hide()
	frame = 7
	await get_tree().create_timer(1.5).timeout
	show()
	
func reset():
	pass

func _process(delta: float) -> void:
	pass
