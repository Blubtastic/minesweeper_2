extends Node

var score = 0
var world_speed = 1.5
var is_player_flying: bool = false

func _ready():
	set_percussion_enabled(false)
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		score = 0
	
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
