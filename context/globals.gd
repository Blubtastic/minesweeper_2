extends Node

var default_world_speed: float = 1.0
var world_speed: float = 1.0
var is_2p: bool = false
var game_mode: float = 0 # 0 is Stress, 1 is Chill
var game_over: bool = false
var score: int = 0
var top_offset: float = 9
var world_height: float = 10

var shared_hp: int = 3
var players_invincible: bool = false
var player_speed: float = 7 # in the future, should be local
var player_positions = { 1: Vector3.ZERO, 2: Vector3.ZERO }

signal game_ended()
signal start_exploded_cube_effects()
signal shared_hp_changed(new_hp)


func _physics_process(_delta: float):
	if game_mode == 1 and !game_over:
		move_camera()


func move_camera():
	var average_z_position = (player_positions[1].z + player_positions[2].z) / 2
	var z_position = (average_z_position if is_2p else player_positions[1].z)  + top_offset
	var ratio = 1 - (z_position / world_height)
	set_world_speed(clamp(ratio * player_speed, 0, player_speed))


func set_shared_hp(new_hp: int) -> void:
	shared_hp_changed.emit(new_hp)
	shared_hp = new_hp


func set_world_speed(speed: float):
	world_speed = speed


func set_player_position(player_num: int, position: Vector3):
	player_positions[player_num] = position


func end_game():
	if game_over == false:
		game_ended.emit()
		game_over = true


func reset_game():
	set_world_speed(default_world_speed)
	game_over = false
	score = 0
	players_invincible = false
	shared_hp = 3


func exploded_cube_effects():
	start_exploded_cube_effects.emit()
