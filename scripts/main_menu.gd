extends Control
@onready var titleScreen = $titleScreen
@onready var gamemodeScreen = $gamemodeScreen
@onready var endlessOptions = $gamemodeScreen/endlessOptions
@onready var normalOptions = $gamemodeScreen/normalOptions
@onready var spinBox = $gamemodeScreen/normalOptions/SpinBox

func _ready() -> void:
	show()
	titleScreen.show()
	gamemodeScreen.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	global.reset.connect(resetGame)

func _process(delta: float) -> void:
	spinBox.value = global.difficulty

func resetGame():
	global.game_active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if visible:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1.0)
		await tween.finished
		modulate.a = 1.0
		hide()
	await get_tree().create_timer(0.25).timeout
	global.begin.emit()

func _on_begin_round_pressed() -> void:
	resetGame()

func _on_begin_pressed() -> void:
	titleScreen.hide()
	gamemodeScreen.show()
	normalOptions.show()
	endlessOptions.hide()

func _on_options_pressed() -> void:
	pass 

func _on_quit_pressed() -> void:
	pass


func _on_tab_bar_tab_changed(tab: int) -> void:
	if tab == 0:
		endlessOptions.hide()
		normalOptions.show()
		global.gamemode = 1
	else:
		endlessOptions.show()
		normalOptions.hide()
		global.gamemode = 2
		
func _on_easy_logo_pressed() -> void:
	global.difficulty = 300.0

func _on_normal_logo_pressed() -> void:
	global.difficulty = 500.0

func _on_semi_bullet_logo_pressed() -> void:
	global.difficulty = 700.0
	
func _on_bullet_logo_pressed() -> void:
	global.difficulty = 900.0

func _on_spin_box_value_changed(value: float) -> void:
	global.difficulty = value
