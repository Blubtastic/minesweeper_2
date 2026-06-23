extends CharacterBody3D

# ==================== INPUT CONFIGURATION ====================
@export_range(1,2) var player_id := 1

# ==================== MOVEMENT PHYSICS ====================
@export var base_speed: float = 5.0  # Base movement speed
@export var forward_speed_bonus: float = 2.0  # Extra speed when moving forward
@export var speed_multiplier: float = 1.0  # Current speed intensity (0-1 range)
const ACCELERATION = 80
const JUMP_VELOCITY = 6.0
const ROTATION_DAMPING = 30.0  # Higher = less rotation tilt
const DAMAGE_UP_VELOCITY = 12.0
const DEATH_UP_VELOCITY = 40.0


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	update_jump()
	update_horizontal_movement(delta)
	update_rotation_tilt()
	move_and_slide()


# ==================== JUMP AND GRAVITY ====================
func update_jump() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump_player" + str(player_id)):
		velocity.y = JUMP_VELOCITY


func apply_gravity(delta: float) -> void:
	velocity += get_gravity() * 2.0 * delta


# ==================== HORIZONTAL MOVEMENT ====================
func update_horizontal_movement(delta: float) -> void:
	var input_dir := Input.get_vector(
		"move_left_player" + str(player_id),
		"move_right_player" + str(player_id),
		"move_up_player" + str(player_id),
		"move_down_player" + str(player_id),
	)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		apply_movement(direction, delta)
	else:
		decelerate(delta)


func apply_movement(direction: Vector3, delta: float) -> void:
	# Lateral movement
	var max_x_velocity := direction.x * base_speed * speed_multiplier
	velocity.x = move_toward(velocity.x, max_x_velocity, ACCELERATION * delta)

	# Forward/backward movement (with directional bonus)
	var z_speed := base_speed if direction.z > 0 else base_speed + forward_speed_bonus
	var max_z_velocity := direction.z * z_speed * speed_multiplier + Globals.world_speed
	velocity.z = move_toward(velocity.z, max_z_velocity, ACCELERATION * delta)


func decelerate(delta: float) -> void:
	var decel_rate := ACCELERATION * delta
	velocity.x = move_toward(velocity.x, 0.0, decel_rate)
	velocity.z = move_toward(velocity.z, Globals.world_speed, decel_rate)


func launch_self_upwards(is_dead: float) -> void:
	velocity.y = DEATH_UP_VELOCITY if is_dead else DAMAGE_UP_VELOCITY


func update_rotation_tilt() -> void:
	rotation.z = -velocity.x / ROTATION_DAMPING
	rotation.x = -velocity.z / ROTATION_DAMPING
