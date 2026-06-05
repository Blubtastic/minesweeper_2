extends CharacterBody3D

# ==================== INPUT CONFIGURATION ====================
@export var inputs: Dictionary[String, String] = {
	"left" = "ui_left",
	"right" = "ui_right",
	"up" = "ui_up",
	"down" = "ui_down",
	"jump" = "ui_accept"
}

# ==================== GAMEPLAY CONFIG ====================
@export var hp: int = 3
@export var sparks: PackedScene
@export var poof: PackedScene

# ==================== MOVEMENT PARAMETERS ====================
@export var base_speed: float = 5.0  # Base movement speed
@export var forward_speed_bonus: float = 2.0  # Extra speed when moving forward
@export var speed_multiplier: float = 1.0  # Current speed intensity (0-1 range)

# ==================== MOVEMENT PHYSICS ====================
const ACCELERATION = 80
const JUMP_VELOCITY = 6.0
const JUMP_PARTICLE_OFFSET_Y = -0.16
const ROTATION_DAMPING = 30.0  # Higher = less rotation tilt
const DEBRIS_PARTICLE_OFFSET_Y = -0.16

const DAMAGE_VELOCITY = 12.0
const DEATH_TERMINAL_VELOCITY = 40.0

const SHIELD_OPACITY_GOAL_ACTIVE = 0.5
const SHIELD_OPACITY_GOAL_INACTIVE = 0.0
const SHIELD_OPACITY_LERP_SPEED = 15.0

const INVINCIBILITY_DURATION = 1.0
const INVINCIBILITY_RECOVERY_DELAY = 0.5
const TRAIL_VFX_DURATION = 1.0
const TRAIL_VFX_FADE_DURATION = 1.0

const TRAIL_VFX = preload("uid://drynt1383xlht")
@onready var shield_mesh: MeshInstance3D = $ShieldMesh
@onready var cube_hitbox: Area3D = $CubeHitbox
@onready var left_debris: Node3D = $TireDebrisSnowLeft
@onready var right_debris: Node3D = $TireDebrisSnowRight

# ==================== INTERNAL STATE ====================
var external_speed: float = 0.0  # Speed applied externally (e.g., by moving platforms)
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
var shield_opacity: float = 0.0  # Current shield visual opacity
var is_dead: bool = false  # Track if player is dead


signal is_flying_changed(is_flying: bool)
signal was_damaged(current_hp: int)


func _physics_process(delta: float) -> void:
	update_visuals(delta)
	update_jump_and_gravity(delta)
	update_horizontal_movement(delta)
	update_rotation_tilt()
	move_and_slide()


# ==================== VISUAL UPDATES ====================
func update_visuals(delta: float) -> void:
	update_collision_particles()
	update_shield_visual(delta)


func update_collision_particles() -> void:
	var collision = get_last_slide_collision()
	if collision and collision.get_angle() == 0.0:
		fire_oneshot_particle(sparks, DEBRIS_PARTICLE_OFFSET_Y)


# ==================== JUMP AND GRAVITY ====================
func update_jump_and_gravity(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed(inputs.jump):
			apply_jump()
	else:
		apply_gravity(delta)


func apply_jump() -> void:
	velocity.y = JUMP_VELOCITY
	fire_oneshot_particle(poof, JUMP_PARTICLE_OFFSET_Y)


func apply_gravity(delta: float) -> void:
	velocity += get_gravity() * 2.0 * delta


# ==================== HORIZONTAL MOVEMENT ====================
func update_horizontal_movement(delta: float) -> void:
	var input_dir := Input.get_vector(inputs.left, inputs.right, inputs.up, inputs.down) + joystick_direction
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and hp > 0:
		apply_movement(direction, delta)
		update_debris(is_on_floor())
	else:
		apply_deceleration(delta)
		update_debris(false)


func apply_movement(direction: Vector3, delta: float) -> void:
	# Lateral movement
	var max_x_velocity = direction.x * base_speed * speed_multiplier
	velocity.x = move_toward(velocity.x, max_x_velocity, ACCELERATION * delta)

	# Forward/backward movement (with directional bonus)
	var z_speed = base_speed if direction.z > 0 else base_speed + forward_speed_bonus
	var max_z_velocity = direction.z * z_speed * speed_multiplier + external_speed
	velocity.z = move_toward(velocity.z, max_z_velocity, ACCELERATION * delta)


func apply_deceleration(delta: float) -> void:
	var decel_rate = ACCELERATION * delta
	velocity.x = move_toward(velocity.x, 0.0, decel_rate)
	velocity.z = move_toward(velocity.z, external_speed, decel_rate)


func update_debris(should_emit: bool) -> void:
	if should_emit:
		emit_debris()
	else:
		stop_debris()


# ==================== ROTATION AND TILT ====================
func update_rotation_tilt() -> void:
	rotation.z = -velocity.x / ROTATION_DAMPING
	rotation.x = -velocity.z / ROTATION_DAMPING


# ==================== DAMAGE AND KNOCKBACK ====================
func damage() -> void:
	if not Globals.players_invincible:
		hp -= 1
		is_dead = (hp <= 0)
		was_damaged.emit(hp)

	# Apply knockback velocity
	velocity.y = DEATH_TERMINAL_VELOCITY if is_dead else DAMAGE_VELOCITY
	is_flying_changed.emit(true)

	# Trigger invincibility period
	Globals.players_invincible = true
	spawn_damage_trail_vfx()
	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout

	Globals.players_invincible = false
	is_flying_changed.emit(false)

	await get_tree().create_timer(INVINCIBILITY_RECOVERY_DELAY).timeout
	cleanup_damage_trail_vfx()


func spawn_damage_trail_vfx() -> void:
	var trail_vfx = TRAIL_VFX.instantiate()
	add_child(trail_vfx)
	trail_vfx.name = "DamageTrailVFX"


func cleanup_damage_trail_vfx() -> void:
	var trail_vfx = get_node_or_null("DamageTrailVFX")
	if not trail_vfx:
		return

	await get_tree().create_timer(TRAIL_VFX_DURATION).timeout
	trail_vfx.get_node("Smoke").emitting = false
	trail_vfx.get_node("Fire").emitting = false

	await get_tree().create_timer(TRAIL_VFX_FADE_DURATION).timeout
	trail_vfx.queue_free()


# ==================== SHIELD VISUAL ====================
func update_shield_visual(delta: float) -> void:
	var mat = shield_mesh.get_active_material(0)
	if not mat or not mat is StandardMaterial3D:
		return

	var goal_opacity = SHIELD_OPACITY_GOAL_ACTIVE if Globals.players_invincible else SHIELD_OPACITY_GOAL_INACTIVE
	shield_opacity = lerpf(shield_opacity, goal_opacity, delta * SHIELD_OPACITY_LERP_SPEED)
	mat.albedo_color.a = shield_opacity


# ==================== PARTICLE EFFECTS ====================
func fire_particle(particle: PackedScene) -> void:
	var particle_instance = particle.instantiate()
	particle_instance.transform.origin = transform.origin
	add_sibling(particle_instance)


func fire_oneshot_particle(scene: PackedScene, offset_y: float) -> void:
	var instance = scene.instantiate()
	add_sibling(instance)
	instance.global_position = Vector3(global_position.x, global_position.y + offset_y, global_position.z)


# ==================== DEBRIS MANAGEMENT ====================
func emit_debris() -> void:
	left_debris.emit_debris()
	right_debris.emit_debris()


func stop_debris() -> void:
	left_debris.stop_debris()
	right_debris.stop_debris()


# ==================== COLLISION CALLBACKS ====================
func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage()
