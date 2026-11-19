extends Node
signal reset
signal death
signal begin
signal success
var pause_toggle: bool = false
var player_health = 100.0
var game_active = false
var roundReady = false
var dead = false
var difficulty = 500
var baseRoundTime = 60.0
var roundTime = baseRoundTime
var gamemode = 1
var score = 0
var record = 0
var difficulty_record = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
