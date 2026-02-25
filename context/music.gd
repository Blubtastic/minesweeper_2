extends Node

@onready var drums_player: AudioStreamPlayer = $DrumsPlayer
@onready var bass_player: AudioStreamPlayer = $BassPlayer
@onready var tambourine: AudioStreamPlayer = $Tambourine

func stop_music():
	drums_player.stop()
	bass_player.stop()
	tambourine.stop()
func restart_music():
	drums_player.play()
	bass_player.play()
	tambourine.play()

func mute_drums(mute: bool):
	drums_player.volume_db = -80 if mute else 0
func mute_tambourine(mute: bool):
	tambourine.volume_db = -80 if mute else 0


# ---

func add_music_low_pass_filter():
	set_music_low_pass_filter(true)
func remove_music_low_pass_filter():
	set_music_low_pass_filter(false)

func set_music_low_pass_filter(enabled: bool):
	var bus_index = AudioServer.get_bus_index("Music")
	var effect = AudioServer.get_bus_effect(bus_index, 0) # hard coded to first since we only have 1 atm.
	if effect is AudioEffectLowPassFilter:
		AudioServer.set_bus_effect_enabled(bus_index, 0, enabled)
