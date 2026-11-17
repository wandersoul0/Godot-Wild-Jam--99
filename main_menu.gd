extends Control
@onready var titleScreen = $titleScreen
@onready var gamemodeScreen = $gamemodeScreen
@onready var endlessOptions = $gamemodeScreen/endlessOptions
@onready var normalOptions = $gamemodeScreen/normalOptions

func _ready() -> void:
	show()
	titleScreen.show()
	gamemodeScreen.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	pass	


func _on_begin_pressed() -> void:
	titleScreen.hide()
	gamemodeScreen.show()

func _on_options_pressed() -> void:
	pass 

func _on_quit_pressed() -> void:
	pass


func _on_tab_bar_tab_changed(tab: int) -> void:
	if tab == 0:
		endlessOptions.hide()
		normalOptions.show()
	else:
		endlessOptions.show()
		normalOptions.hide()


func _on_begin_round_pressed() -> void:
	global.game_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	modulate.a = 1.0
	titleScreen.hide()
	gamemodeScreen.hide()
	hide()
	await get_tree().create_timer(0.25).timeout
	global.begin.emit()
