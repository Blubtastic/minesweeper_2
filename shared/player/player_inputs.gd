extends Node

class_name PlayerInputs

var move_left_player: String
var move_right_player: String
var move_up_player: String
var move_down_player: String
var jump_player: String
var use_powerup_player: String

func _init(left: String, right: String, up: String, down: String, jump: String, use_powerup: String) -> void:
	self.move_left_player = left
	self.move_right_player = right
	self.move_up_player = up
	self.move_down_player = down
	self.jump_player = jump
	self.use_powerup_player = use_powerup
