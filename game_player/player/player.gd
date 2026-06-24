extends CharacterBody3D
class_name Player

@export_range(1,2) var player_id := 1
@export var hp: int = 3
var is_dead: bool = false
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
var player_movement := PlayerMovement.new(self)
@onready var visual_effects := $VisualEffects

signal was_damaged(current_hp: int)


func _physics_process(delta: float) -> void:
	## Input setup could be moved to its own class.
	var input_dir := Input.get_vector(
		"move_left_player" + str(player_id),
		"move_right_player" + str(player_id),
		"move_up_player" + str(player_id),
		"move_down_player" + str(player_id),
	)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player_movement.handle_base_movement(delta)
	player_movement.update_horizontal_movement(direction, delta)
	visual_effects.update_visuals(delta)
	visual_effects.handle_tire_debris(direction, hp)

	if is_on_floor() and Input.is_action_just_pressed("jump_player" + str(player_id)):
		player_movement.jump()
		visual_effects.fire_poof_below_player()


func damage() -> void:
	if not Globals.players_invincible:
		hp -= 1
		is_dead = (hp <= 0)
		was_damaged.emit(hp)

	TimerHelper.true_for_duration(Globals, "players_invincible", 1.0)
	player_movement.launch_self_upwards(is_dead)
	visual_effects.handle_damage_trail_vfx(1.5)
	Music.start_low_pass_filter()


# ==================== COLLISION CALLBACKS ====================
func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)
