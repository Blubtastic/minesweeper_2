extends Node

class_name PlayerMovement


# ==================== MOVEMENT PHYSICS ====================
@export var base_speed: float = 5.0  # Base movement speed
@export var forward_speed_bonus: float = 2.0  # Extra speed when moving forward
@export var speed_multiplier: float = 1.0  # Current speed intensity (0-1 range)
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
const ACCELERATION = 80
const JUMP_VELOCITY = 6.0
const ROTATION_DAMPING = 30.0  # Higher = less rotation tilt
const DAMAGE_UP_VELOCITY = 12.0
const DEATH_UP_VELOCITY = 40.0
var p: Player


func _init(player: Player) -> void:
	p = player


func _ready() -> void:
	base_speed = Globals.player_speed


func handle_base_movement(delta: float) -> void:
	apply_gravity(delta)
	update_rotation_tilt()
	p.move_and_slide()


func jump() -> void:
	p.velocity.y = JUMP_VELOCITY


func apply_gravity(delta: float) -> void:
	p.velocity += p.get_gravity() * 2.0 * delta


func update_horizontal_movement(direction: Vector3, delta: float) -> void:
	var total_direction := Vector3(direction.x + joystick_direction.x, direction.y, direction.z + joystick_direction.y)

	if total_direction:
		apply_movement(total_direction, delta)
	else:
		decelerate(delta)


func apply_movement(direction: Vector3, delta: float) -> void:
	# Lateral movement
	var max_x_velocity := direction.x * base_speed * speed_multiplier
	p.velocity.x = move_toward(p.velocity.x, max_x_velocity, ACCELERATION * delta)

	# Forward/backward movement (with directional bonus)
	var z_speed := base_speed if direction.z > 0 else base_speed + forward_speed_bonus
	var max_z_velocity: float = direction.z * z_speed * speed_multiplier + Globals.world_speed
	p.velocity.z = move_toward(p.velocity.z, max_z_velocity, ACCELERATION * delta)


func decelerate(delta: float) -> void:
	var decel_rate := ACCELERATION * delta
	p.velocity.x = move_toward(p.velocity.x, 0.0, decel_rate)
	p.velocity.z = move_toward(p.velocity.z, Globals.world_speed, decel_rate)


func launch_self_upwards(is_dead: float) -> void:
	p.velocity.y = DEATH_UP_VELOCITY if is_dead else DAMAGE_UP_VELOCITY


func update_rotation_tilt() -> void:
	p.rotation.z = -p.velocity.x / ROTATION_DAMPING
	p.rotation.x = -p.velocity.z / ROTATION_DAMPING
