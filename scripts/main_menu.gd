extends Control
@onready var cursorCircle = get_node_or_null("/root/main/mainGame/cursorCircle")
@onready var titleScreen = $titleScreen
@onready var gamemodeScreen = $gamemodeScreen
@onready var endlessOptions = $gamemodeScreen/endlessOptions
@onready var normalOptions = $gamemodeScreen/normalOptions
@onready var spinBox = $gamemodeScreen/normalOptions/SpinBox
@onready var deathScreen = $deathScreen
@onready var winScreen = $winScreen
@onready var pauseMenu = $pauseMenu
@onready var howToPlayScreen = $howToPlay
@onready var deathScreenHum = $sound/deathScreenHum
var show_toggle = true

func _ready() -> void:
	show()
	titleScreen.show()
	gamemodeScreen.hide()
	deathScreen.hide()
	winScreen.hide()
	pauseMenu.hide()
	howToPlayScreen.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	global.reset.connect(resetGame)
	global.death.connect(death)
	global.success.connect(win)

func _process(delta: float) -> void:
	spinBox.value = global.difficulty
	if global.pause_toggle == true:
		pauseMenu.show()
		if not visible:
			show_toggle = false
			show()
	else:
		pauseMenu.hide()
		if show_toggle == false:
			show_toggle = true
			hide()

func resetGame():
	get_viewport().gui_disable_input = true
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
	titleScreen.show()
	gamemodeScreen.hide()
	
func death():
	deathScreenHum.play()
	cursorCircle.roundTimer.stop()
	titleScreen.hide()
	gamemodeScreen.hide()
	winScreen.hide()
	deathScreen.show()
	show()
	
func win():
	if global.gamemode == 2:
		return
	deathScreenHum.play()
	titleScreen.hide()
	gamemodeScreen.hide()
	winScreen.show()
	deathScreen.show()
	show()

func _on_begin_round_pressed() -> void:
	resetGame()

func _on_begin_pressed() -> void:
	titleScreen.hide()
	gamemodeScreen.show()

func _on_options_pressed() -> void:
	pass 

func _on_quit_pressed() -> void:
	get_tree().quit()


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

func _on_try_again_button_pressed() -> void:
	deathScreenHum.stop()
	deathScreen.hide()
	hide()
	global.reset.emit()

func _on_return_to_main_screen_button_pressed() -> void:
	deathScreenHum.stop()
	cursorCircle.roundTimer.stop()
	if global.pause_toggle:
		cursorCircle.toggle_pause()
	global.pause_toggle = false
	Engine.time_scale = 1.0
	global.roundReady = false
	global.game_active = false
	global.score = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pauseMenu.hide()
	gamemodeScreen.hide()
	winScreen.hide()
	deathScreen.hide()
	titleScreen.show()
	show_toggle = true
	show()
	
func _on_unpause_pressed() -> void:
	cursorCircle.toggle_pause()

func _on_how_to_play_pressed() -> void:
	howToPlayScreen.show()
	titleScreen.hide()

func _on_return_pressed() -> void:
	howToPlayScreen.hide()
	titleScreen.show()

func _on_return_2_pressed() -> void:
	gamemodeScreen.hide()
	titleScreen.show()
