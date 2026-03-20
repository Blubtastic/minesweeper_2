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

func _physics_process(delta: float):
	# Accelerate camera based on player position
	if game_mode == 1 and !is_2p:
		if player1_position.z > 1:
			world_speed = lerpf(world_speed, 0, 2*delta)
		else:
			world_speed = lerpf(world_speed, initial_world_speed*7, 0.7*delta)

# TODO: Intuitive camera acceleration idea 2:
# WHAT: Increase speed the closer the player are to screen top.
# HOW: 
# - Set up some vars: 
#   - player_speed (hardcode to 7 for now)
#   - SCREEN_BOT (camera stands still)
#   - SCREEN_TOP (camera moves at max speed)
# - then set camera speed (world_speed) based on where 
#   player_position is within [SCREEN_BOT, SCREEN_TOP].
