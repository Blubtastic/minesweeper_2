extends Node

var player_hp: int
var score = 0
var world_speed = 1
var game_over: bool = false

signal game_ended()

func _ready():
	set_percussion_enabled(false)

func add_music_low_pass_filter():
	set_music_low_pass_filter(true)
func remove_music_low_pass_filter():
	set_music_low_pass_filter(false)

func set_music_low_pass_filter(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Music")
	var effect = AudioServer.get_bus_effect(bus_index, 0) # hard coded to first since we only have 1 atm.
	if effect is AudioEffectLowPassFilter:
		AudioServer.set_bus_effect_enabled(bus_index, 0, enabled)

func set_percussion_enabled(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Percussion")
	AudioServer.set_bus_mute(bus_index, !enabled)

func end_game():
	if game_over == false:
		game_ended.emit()
		game_over = true

func reset_game():
	set_percussion_enabled(false)
	score = 0
	game_over = false
