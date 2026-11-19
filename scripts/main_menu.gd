extends Control
@onready var cursorCircle = get_node_or_null("/root/main/mainGame/cursorCircle")
@onready var world_env = get_node_or_null("/root/main/WorldEnv")
@onready var titleScreen = $titleScreen
@onready var gamemodeScreen = $gamemodeScreen
@onready var endlessOptions = $gamemodeScreen/endlessOptions
@onready var normalOptions = $gamemodeScreen/normalOptions
@onready var spinBox = $gamemodeScreen/normalOptions/SpinBox
@onready var deathScreen = $deathScreen
@onready var winScreen = $winScreen
@onready var pauseMenu = $pauseMenu
@onready var howToPlayScreen = $howToPlay
@onready var optionsMenu = $options
@onready var deathScreenHum = $sound/deathScreenHum
@onready var mainRoundMusic = $sound/mainRoundMusic
@onready var endlessMusic = $sound/endlessMusic
@onready var brightnessSlider = $options/brightness
@onready var musicVolumeSlider = $options/musicVolume
@onready var masterVolumeSlider = $options/masterVolume
var show_toggle = true
var bus_idx

func _ready() -> void:
	show()
	titleScreen.show()
	gamemodeScreen.hide()
	deathScreen.hide()
	winScreen.hide()
	pauseMenu.hide()
	howToPlayScreen.hide()
	optionsMenu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	global.reset.connect(resetGame)
	global.death.connect(death)
	global.success.connect(win)
	global.begin.connect(begin)
	global.masterVolume = masterVolumeSlider.value
	bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		var linear_volume: float = masterVolumeSlider.value / 50.0
		var db_volume := linear_to_db(linear_volume)
		AudioServer.set_bus_volume_db(bus_idx, db_volume)
	global.musicVolume = musicVolumeSlider.value
	bus_idx = AudioServer.get_bus_index("Music")
	if bus_idx != -1:
		var linear_volume: float = global.musicVolume / 90.0
		var db_volume := linear_to_db(linear_volume)
		AudioServer.set_bus_volume_db(bus_idx, db_volume)
		
func begin():
	if global.gamemode == 2:
		endlessMusic.play()

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
	global.score = 0
	if global.gamemode == 1:
		mainRoundMusic.play()
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
	mainRoundMusic.stop()
	endlessMusic.stop()
	cursorCircle.roundTimer.stop()
	titleScreen.hide()
	gamemodeScreen.hide()
	winScreen.hide()
	deathScreen.show()
	show()
	if global.gamemode == 2:
		if global.score > global.record:
			global.record = global.score
	
func win():
	if global.gamemode == 2:
		return
	mainRoundMusic.stop()
	endlessMusic.stop()
	deathScreenHum.play()
	titleScreen.hide()
	gamemodeScreen.hide()
	deathScreen.show()
	show()

func _on_begin_round_pressed() -> void:
	resetGame()

func _on_begin_pressed() -> void:
	titleScreen.hide()
	gamemodeScreen.show()

func _on_options_pressed() -> void:
	optionsMenu.show()

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
	mainRoundMusic.stop()
	endlessMusic.stop()
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
	
func _on_return_3_pressed() -> void:
	optionsMenu.hide()

func _on_brightness_drag_ended(value_changed: bool) -> void:
	global.brightness = brightnessSlider.value
	world_env.environment.adjustment_brightness = global.brightness/50.0
	
func _on_master_volume_drag_ended(value_changed: bool) -> void:
	global.masterVolume = masterVolumeSlider.value

func _on_music_volume_drag_ended(value_changed: bool) -> void:
	global.musicVolume = musicVolumeSlider.value

func _on_check_box_pressed() -> void:
	global.skipDeathAnim = !global.skipDeathAnim
