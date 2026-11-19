extends Label
@onready var label = $"."

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	label.text = (("Difficulty: ") + str(global.difficulty))
