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
var player_speed: float = 5 # in the future, should be local
var player_positions := { 1: Vector3.ZERO, 2: Vector3.ZERO }

signal game_ended()
signal cube_exploded()
signal player_was_damaged()
signal shared_hp_changed(new_hp: int)


func _physics_process(_delta: float) -> void:
	if game_mode == 1 and !game_over:
		move_world()


func move_world() -> void:
	var average_z_position: float = (player_positions[1].z + player_positions[2].z) / 2
	var z_position: float = (average_z_position if is_2p else player_positions[1].z)  + top_offset
	var ratio := 1 - (z_position / world_height)
	set_world_speed(clamp(ratio * player_speed, 0, player_speed))


func set_shared_hp(new_hp: int) -> void:
	shared_hp_changed.emit(new_hp)
	shared_hp = new_hp


func set_world_speed(speed: float) -> void:
	world_speed = speed


func set_player_position(player_num: int, position: Vector3) -> void:
	player_positions[player_num] = position


func end_game() -> void:
	if game_over == false:
		game_ended.emit()
		game_over = true


func reset_game() -> void:
	set_world_speed(default_world_speed)
	game_over = false
	players_invincible = false
	score = 0
	shared_hp = 3


func trigger_camera_shake() -> void:
	cube_exploded.emit()

func trigger_camera_jump() -> void:
	player_was_damaged.emit()


func handle_cube_was_cleared(amount: int = 5) -> void:
	Globals.score += amount
