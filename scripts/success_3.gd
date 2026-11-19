extends Label
@onready var label = $"."

func _process(delta: float) -> void:
	label.text = "Difficulty: " + str(global.difficulty)
