extends Node

const SCORE_PARTICLES = preload("uid://cwejm25ywsm0s")

var current_level: int = 0
var default_world_speed: float = 1.0
var world_speed: float = 1.0
var is_2p: bool = false
var dead_player_count: int = 0
var game_mode: float = 0 # 0 is Stress, 1 is Chill
var game_over: bool = false
var level_over: bool = false
var score: int = 0
var top_offset: float = 9
var world_height: float = 10

var players_invincible: bool = false
var player_speed: float = 5 # in the future, should be local
var player_positions := { 1: Vector3.ZERO, 2: Vector3.ZERO }

var level_aced: bool = false
var level_full_cleared: bool = false
var players: Array[Player] = []

signal game_ended()
signal cube_exploded()
signal player_was_damaged()


# ==================== WORLD MOVEMENT ====================
func _physics_process(_delta: float) -> void:
	if not game_over:
		move_world_by_player_positions()


func move_world_by_player_positions() -> void:
	var average_z_position: float = (player_positions[1].z + player_positions[2].z) / 2
	var z_position: float = (average_z_position if is_2p else player_positions[1].z)  + top_offset
	var ratio := 1 - (z_position / world_height)
	set_world_speed(clamp(ratio * player_speed, 0, player_speed))


func set_world_speed(speed: float) -> void:
	world_speed = speed


func set_player_position(player_num: int, position: Vector3) -> void:
	player_positions[player_num] = position


# ==================== END, RESET ====================
func end_game() -> void:
	if is_2p:
		dead_player_count += 1
		if dead_player_count > 1:
			game_ended.emit()
			game_over = true
	elif game_over == false:
		game_ended.emit()
		game_over = true


func reset_game() -> void:
	set_world_speed(default_world_speed)
	game_over = false
	level_over = false
	players_invincible = false
	score = 0
	dead_player_count = 0
	level_aced = false
	level_full_cleared = false
	players = []


# ==================== CAMERA ====================
func trigger_camera_shake() -> void:
	cube_exploded.emit()

func trigger_camera_jump() -> void:
	player_was_damaged.emit()


# ==================== CUBE CLEAR ====================
## Global consequences of the cube being cleared, like score.
func handle_cube_was_cleared(ref: Cube) -> void:
	var score_granted := 1
	if ref.cleared_by is Player:
		if ref.is_bomb:
			score_granted = 0
		else:
			score_granted = 100
			spawn_score_granted_particle(score_granted, ref.global_position)
	if ref.cleared_by is ImpactGrenade:
		if ref.cleared_by.direct_hit == true:
			score_granted = 100
			spawn_score_granted_particle(score_granted, ref.global_position)
	Globals.score += score_granted


func spawn_score_granted_particle(amount: int, pos: Vector3) -> void:
	var score_instance := SCORE_PARTICLES.instantiate()
	add_child(score_instance)
	score_instance.global_position = pos
	score_instance.global_position.y += 1
	score_instance.mesh.text = str(amount)
	score_instance.emitting = true


func set_reward_vars() -> void:
	level_aced = is_level_aced()
	#level_full_cleared: CLEARED = CUBES - MINES


func is_level_aced() -> bool:
	for player in players:
		if player.hp != player.START_HP:
			return false
	return true


func get_players() -> void:
	var players_from_group := get_tree().get_nodes_in_group("players")
	for player in players_from_group:
		if player is Player:
			players.append(player)
