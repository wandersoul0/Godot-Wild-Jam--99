extends BaseButton
@onready var hover_sound = get_node("/root/main/mainMenu/sound/buttonClick2")
@onready var pressed_sound = get_node("/root/main/mainMenu/sound/buttonClick1")

func _ready() -> void:
	mouse_entered.connect(_on_hover)
	pressed.connect(_on_pressed)

func _on_hover() -> void:
	hover_sound.play()

func _on_pressed() -> void:
	pressed_sound.play()
