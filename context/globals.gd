extends Node

const SCORE_PARTICLES = preload("uid://cwejm25ywsm0s")

## NOT USED ACTIVELY
var score: int = 0

## SELECTED LEVEL
var current_level: int = 0
var current_group: int = 1
var is_level_over: bool = false
var is_level_failed: bool = false

## WORLD MOVEMENT
var default_world_speed: float = 1.0
var world_speed: float = 1.0
var world_speed_strength: float = 2.0
var top_offset: float = 12
var world_height: float = 10

## PLAYERS
var is_2p: bool = false
var dead_player_count: int = 0
var players_invincible: bool = false
var player_speed: float = 5 # in the future, should be local
var player_positions := { 1: Vector3.ZERO, 2: Vector3.ZERO }

## EVENTS
signal level_failed()
signal level_completed()
signal cube_exploded()
signal a_player_was_damaged()


func _ready() -> void:
	Storage.load_game()


# ==================== WORLD MOVEMENT ====================
func _physics_process(_delta: float) -> void:
	if not is_level_failed:
		move_world_by_player_positions()

func move_world_by_player_positions() -> void:
	var average_z_position: float = (player_positions[1].z + player_positions[2].z) / 2
	var z_position: float = (average_z_position if is_2p else player_positions[1].z)  + top_offset
	var ratio := 1 - (z_position / world_height)
	set_world_speed(clamp(ratio*world_speed_strength * player_speed, 0, player_speed))


func set_world_speed(speed: float) -> void:
	world_speed = speed

func set_player_position(player_num: int, position: Vector3) -> void:
	player_positions[player_num] = position


# ==================== FAIL AND RESET LEVEL ====================
func handle_player_died() -> void:
	if is_level_failed == true:
		return
	if !is_2p:
		level_failed.emit()
		is_level_failed = true
		return

	dead_player_count += 1
	if dead_player_count > 1:
		level_failed.emit()
		is_level_failed = true


func reset_level() -> void:
	set_world_speed(default_world_speed)
	is_level_failed = false
	is_level_over = false
	players_invincible = false
	score = 0
	dead_player_count = 0
	Storage.reset_level()


# ==================== CAMERA ====================
func trigger_camera_shake() -> void:
	cube_exploded.emit()

func trigger_camera_jump() -> void:
	a_player_was_damaged.emit()

func trigger_level_completed() -> void:
	level_completed.emit()
	Storage.save_game()


# ==================== EFFECTS OF CUBE CLEARED ====================
## Global consequences of the cube being cleared, like score.
func handle_cube_was_cleared(ref: Cube) -> void:
	var score_granted := 1
	if !ref.is_bomb:
		Storage.increase_cleared_cubes_by_one()
	if ref.cleared_by is Player: # Move to player.gd? context shouldn't know about features
		if ref.is_bomb:
			score_granted = 0
		else:
			score_granted = 100
			#spawn_score_granted_particle(score_granted, ref.global_position)
	if ref.cleared_by is ImpactGrenade:
		if ref.cleared_by.direct_hit == true:
			score_granted = 100
			#spawn_score_granted_particle(score_granted, ref.global_position)
	Globals.score += score_granted


#func spawn_score_granted_particle(amount: int, pos: Vector3) -> void:
	#var score_instance := SCORE_PARTICLES.instantiate()
	#add_child(score_instance)
	#score_instance.global_position = pos
	#score_instance.global_position.y += 1
	#score_instance.mesh.text = str(amount)
	#score_instance.emitting = true
