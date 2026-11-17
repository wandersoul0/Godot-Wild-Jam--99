extends CanvasLayer

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)
	hide()

func death():
	show()
	
func reset():
	pass

func _process(delta: float) -> void:
	pass
