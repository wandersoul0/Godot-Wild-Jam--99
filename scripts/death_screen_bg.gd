extends CanvasLayer

func _ready():
	global.reset.connect(reset)
	global.death.connect(death)
	hide()

func death():
	show()
	
func reset():
	hide()

func _process(delta: float) -> void:
	pass

func _on_try_again_button_pressed() -> void:
	hide()
	global.reset.emit()
