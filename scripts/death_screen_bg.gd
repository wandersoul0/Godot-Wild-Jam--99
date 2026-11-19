extends Control

func _ready():
	global.death.connect(death)
	hide()

func death():
	show()
	
