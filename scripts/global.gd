extends Node
signal reset
signal death
signal begin
var pause_toggle: bool = false
var player_health = 100.0
var game_active = false
var roundReady = false
var dead = false
var difficulty = 1000

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
