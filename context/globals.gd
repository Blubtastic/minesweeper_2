extends Node

var player_hp: int
var score = 0
var initial_world_speed: float = 1.0
var world_speed: float = 1.0
var game_over: bool = false

signal game_ended()
signal start_exploded_cube_effects()

func set_world_speed(speed: float):
	world_speed = speed

func end_game():
	if game_over == false:
		game_ended.emit()
		game_over = true

func reset_game():
	score = 0
	game_over = false
	world_speed = initial_world_speed

func exploded_cube_effects():
	start_exploded_cube_effects.emit()
