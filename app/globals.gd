extends Node

const PLAYER_HP_START: int = 1
var player_hp: int
var score = 0
var world_speed = 1.5
var is_player_flying: bool = false
var game_over: bool = false

signal game_ended()

func _ready():
	player_hp = PLAYER_HP_START
	set_percussion_enabled(false)
	
func _physics_process(_delta: float) -> void:

	# enable bass when player first explodes
	if is_player_flying:
		set_percussion_enabled(true)
	# Low pass music filter while player is flying
	set_music_low_pass_filter(is_player_flying)

func add_music_low_pass_filter():
	pass
func remove_music_low_pass_filter():
	pass

func set_music_low_pass_filter(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Music")
	var effect = AudioServer.get_bus_effect(bus_index, 0) # hard coded to first since we only have 1 atm.
	if effect is AudioEffectLowPassFilter:
		AudioServer.set_bus_effect_enabled(bus_index, 0, enabled)

func set_percussion_enabled(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Percussion")
	AudioServer.set_bus_mute(bus_index, !enabled)

func damage_player(damage: int):
	if (player_hp - damage <= 0):
		if game_over == false:
			game_ended.emit()
			game_over = true
	player_hp -= damage

func reset_game():
	set_percussion_enabled(false)
	player_hp = PLAYER_HP_START
	score = 0
	world_speed = 1.5
	is_player_flying = false
	game_over = false
