extends Label
@onready var label = $"."


func _ready() -> void:
	hide()
	global.begin.connect(begin)

func _process(_delta: float) -> void:
	label.text = str(int(ceil(global.roundTime)))
	
func begin():
	show()
