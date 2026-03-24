extends Node

var is_2p: bool = false
var initial_world_speed: float = 1.0
var world_speed: float = 1.0
var game_over: bool = false
var game_mode: float = 0 # 0 is Stress, 1 is Chill

var score = 0
var player_hp: int
var player1_position: Vector3 = Vector3.ZERO
var player1_velocity: Vector3 = Vector3.ZERO

# global parameter is_2p
var score_2 = 0

signal game_ended()
signal start_exploded_cube_effects()

func set_world_speed(speed: float):
	world_speed = speed

func set_player1_position(position: Vector3):
	player1_position = position

func set_player1_velocity(velocity: Vector3):
	player1_velocity = velocity

func player_died():
	if game_over == false:
		game_ended.emit()
		game_over = true

func reset_game():
	score = 0
	score_2 = 0
	game_over = false
	world_speed = initial_world_speed

func exploded_cube_effects():
	start_exploded_cube_effects.emit()

# Set world_speed from player_position
# TODO: rewrite hard-coding to react to environment
var player_speed: float = 7
var world_height = 10
var top_offset = 6
func _physics_process(_delta: float):
	if game_mode == 1 and !is_2p and !game_over:
		var player_position_relative = player1_position.z + top_offset
		var ratio = 1 - (player_position_relative / world_height)
		var speed = ratio * initial_world_speed*player_speed
		world_speed = clamp(speed, 0, initial_world_speed*player_speed)
