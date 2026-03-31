extends Node

var default_world_speed: float = 1.0
var world_speed: float = 1.0
var is_2p: bool = false
var game_mode: float = 0 # 0 is Stress, 1 is Chill
var game_over: bool = false
var score = 0
var top_offset = 9
var world_height = 10

# Global player vars
var players_invincible: bool = false
var player_speed: float = 7
var player_hp: int # needs to be local
var player1_position: Vector3 = Vector3.ZERO
var player2_position: Vector3 = Vector3.ZERO

signal game_ended()
signal start_exploded_cube_effects()


func _physics_process(_delta: float):
	if game_mode == 1 and !game_over:
		move_camera()


func move_camera():
	var player2_position_var = player2_position if is_2p else player1_position
	var average_position = (player1_position.z + player2_position_var.z) / 2
	var average_z = average_position + top_offset
	var ratio = 1 - (average_z / world_height)
	set_world_speed(clamp(ratio * player_speed, 0, player_speed))


func set_world_speed(speed: float):
	world_speed = speed

func set_player_position(player_num: int, position: Vector3):
	if player_num == 1:
		player1_position = position
	if player_num == 2:
		player2_position = position


func player_died():
	if game_over == false:
		game_ended.emit()
		game_over = true


func reset_game():
	set_world_speed(default_world_speed)
	game_over = false
	score = 0
	players_invincible = false


func exploded_cube_effects():
	start_exploded_cube_effects.emit()
