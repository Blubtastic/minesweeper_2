extends Node3D

const GAME_OVER = preload("uid://ck8cc332mqpua")
const _1_PLAYER = preload("uid://do0hnve2ge0ub")
const _2_PLAYERS = preload("uid://ccotdq6huom6h")


func filename_stuff() -> void:
	if scene_file_path != "":
		var path := scene_file_path.split(".")[0]
		var current_group: = path.split("_", false, 2)[1]
		var current_level: = path.split("_", false, 2)[2]
		Globals.current_group = int(current_group)
		Globals.current_level = int(current_level)

		var rewards: Dictionary = Globals.rewards_state[Globals.current_group][Globals.current_level]
		var reward1: bool = rewards[1]
		var reward2: bool = rewards[2]
		var reward3: bool = rewards[3]
		print(reward1, reward2, reward3)
	else:
		print("ERROR: scene_file_path not found!")


func _ready() -> void:
	filename_stuff()
	Globals.reset_game()
	Globals.game_ended.connect(_on_game_ended)
	Music.restart_music()
	Music.stop_cozy()
	Music.mute_drums(true)
	Music.mute_tambourine(true)

	if Globals.is_2p:
		var player_2 := _2_PLAYERS.instantiate()
		player_2.position = Vector3(0,1,0)
		add_child(player_2)
	else:
		var player_1 := _1_PLAYER.instantiate()
		player_1.position = Vector3(0,1,0)
		add_child(player_1)
	Globals.get_players()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("restart"):
			get_tree().reload_current_scene()


func _on_game_ended() -> void:
	var game_over_instance := GAME_OVER.instantiate()
	add_child(game_over_instance)
	Music.kill_music()
	var tween := create_tween()
	tween.tween_method(Globals.set_world_speed, Globals.world_speed, 0, 2)
