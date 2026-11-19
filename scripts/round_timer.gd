extends Label

@onready var label = $"."

var time_elapsed: float = 0.0
var is_running: bool = false

func _ready() -> void:
	hide()
	global.begin.connect(begin)
	global.reset.connect(resetGame)

func _process(delta: float) -> void:
	if global.gamemode == 1:
		label.text = str(int(ceil(global.roundTime)))
	else:
		if is_running:
			time_elapsed += delta
		label.text = str(int(time_elapsed))

func begin() -> void:
	time_elapsed = 0.0
	is_running = true
	#tps out of view and then smoothly slides back into view; transition.
	var start_y: float = position.y
	position.y = start_y - 60.0
	show()
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", start_y, 0.35)
	
func resetGame():
	hide()
