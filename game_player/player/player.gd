extends CharacterBody3D
class_name Player

@export_range(1,2) var player_id := 1
@export var hp: int = 3
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
var player_movement := PlayerMovement.new(self)
@onready var visual_effects := $VisualEffects


func _ready() -> void:
	Globals.shared_hp_changed.connect(func(new_hp: int) -> void: hp = new_hp)


func _physics_process(delta: float) -> void:
	Globals.set_player_position(player_id, position)
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
		Globals.set_shared_hp(hp)
		Music.mute_drums(false)
		if hp < 2:
			Music.mute_tambourine(false)
		if hp <= 0:
			Globals.end_game()
			TimerHelper.call_after_time(self, queue_free, 2.0)

	Globals.trigger_camera_jump()
	TimerHelper.true_for_time(Globals, "players_invincible", 1.0)
	player_movement.launch_self_upwards(hp <= 0)
	visual_effects.handle_damage_trail_vfx(1.5)
	Music.start_low_pass_filter()


# ==================== COLLISION CALLBACKS ====================
func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)
