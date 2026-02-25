extends Node

var player_hp: int
var score = 0
var world_speed = 1
var game_over: bool = false

signal game_ended()

func end_game():
	if game_over == false:
		game_ended.emit()
		game_over = true

func reset_game():
	score = 0
	game_over = false
