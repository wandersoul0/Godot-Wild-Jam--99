extends Label
@onready var label = $"."

func _process(delta: float) -> void:
	if global.gamemode == 1:
		label.text = "Difficulty Record: " + str(global.difficulty_record)
	if global.gamemode == 2:
		label.text = "Endless Record: " + str(global.record)
		
