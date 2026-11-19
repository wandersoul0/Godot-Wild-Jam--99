extends Label
@onready var label = $"."

func _ready() -> void:
	hide()
	global.begin.connect(begin)
	global.reset.connect(resetGame)

func _process(delta: float) -> void:
	label.text = str(int(global.score))

func begin():
	#tps out of view and then smoothly slides back into view; transition.
	var start_y: float = position.y
	position.y = start_y - 60.0
	if global.gamemode == 2:
		show()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", start_y, 0.35)
	
func resetGame():
	hide()
