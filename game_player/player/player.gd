extends CharacterBody3D

class_name Player

@export_range(1,2) var player_id := 1
@export var hp: int = 3
var is_dead: bool = false
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
var player_movement := PlayerMovement.new(self)
@onready var visual_effects := $VisualEffects

signal is_flying_changed(is_flying: bool)
signal was_damaged(current_hp: int)


func _physics_process(delta: float) -> void:
	player_movement.handle_base_movement(delta)

	## Input setup could be moved to its own class.
	var input_dir := Input.get_vector(
		"move_left_player" + str(player_id),
		"move_right_player" + str(player_id),
		"move_up_player" + str(player_id),
		"move_down_player" + str(player_id),
	)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player_movement.update_horizontal_movement(direction, delta)

	## JUMP
	if is_on_floor() and Input.is_action_just_pressed("jump_player" + str(player_id)):
		player_movement.jump()
		visual_effects.fire_poof_below_player()

	visual_effects.update_horizontal_debris(direction, hp)
	visual_effects.update_visuals(delta)


##
func damage() -> void:
	if not Globals.players_invincible:
		hp -= 1
		is_dead = (hp <= 0)
		was_damaged.emit(hp)

	player_movement.launch_self_upwards(is_dead)
	visual_effects.handle_damage_trail_vfx(1.5)

	## Use helper function to toggle state for 1.0s
	Globals.players_invincible = true
	## Replace once game_player is merged
	is_flying_changed.emit(true)
	await get_tree().create_timer(1.0).timeout
	Globals.players_invincible = false
	is_flying_changed.emit(false)


# ==================== COLLISION CALLBACKS ====================
func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)
