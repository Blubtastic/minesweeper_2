extends CharacterBody3D

@export var inputs: Dictionary[String, String] = {
	"left" = "ui_left",
	"right" = "ui_right",
	"up" = "ui_up",
	"down" = "ui_down",
	"jump" = "ui_accept"
}
@export var hp: int = 3
@export var speed = 5.0
@export var sparks: PackedScene
@export var poof: PackedScene
var speed_forward = speed+2
var speed_backwards = speed
var external_speed: float = 0
var joystick_direction: Vector2 = Vector2(0,0)
var speed_intensity: float = 1
var shield_opacity: float = 0.0
const JUMP_VELOCITY = 6
const DAMAGED_VELOCITY = 12
const TERMINAL_VELOCITY = 40
const TRAIL_VFX = preload("uid://drynt1383xlht")
@onready var shield_mesh: MeshInstance3D = $ShieldMesh
@onready var cube_hitbox: Area3D = $CubeHitbox
@onready var left_debris: Node3D = $TireDebrisSnowLeft
@onready var right_debris: Node3D = $TireDebrisSnowRight


signal is_flying_changed(is_flying: bool)
signal was_damaged(current_hp: int)


func _physics_process(delta: float) -> void:
	handle_visuals(delta)

	# JUMP & GRAVITY
	if is_on_floor():
		if Input.is_action_just_pressed(inputs.jump):
			velocity.y = JUMP_VELOCITY
			fire_oneshot_particle(poof, -0.16)
	else:
		velocity += get_gravity()*2 * delta

	# MOVEMENT
	var input_dir := Input.get_vector(inputs.left, inputs.right, inputs.up, inputs.down) + joystick_direction
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and hp > 0:
		velocity.x = direction.x * speed * speed_intensity
		if is_on_floor():
			emit_debris()
		else:
			stop_debris()
		if direction.z > 0:
			velocity.z = direction.z * speed_backwards * speed_intensity + external_speed # read
		if direction.z < 0:
			velocity.z = direction.z * speed_forward * speed_intensity + external_speed # read
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_intensity)
		velocity.z = move_toward(velocity.z, external_speed, speed * speed_intensity) # read
		stop_debris()

	# Visuals for rotation - based on speed direction
	rotation.z = -velocity.x / 30
	rotation.x = -velocity.z / 30

	move_and_slide()


func handle_visuals(delta: float):
	update_shield_opacity(delta)
	var collission = get_last_slide_collision()
	if collission and collission.get_angle() == 0.0:
		fire_oneshot_particle(sparks, -0.16)


func damage():
	if not Globals.players_invincible:
		hp -= 1
		was_damaged.emit(hp)
	velocity.y = DAMAGED_VELOCITY if hp > 0 else TERMINAL_VELOCITY
	is_flying_changed.emit(true)
	Globals.players_invincible = true

	var TrailVfx = TRAIL_VFX.instantiate()
	add_child(TrailVfx)
	await get_tree().create_timer(1.0).timeout
	Globals.players_invincible = false
	is_flying_changed.emit(false)
	await get_tree().create_timer(0.5).timeout
	TrailVfx.get_node("Smoke").emitting = false
	TrailVfx.get_node("Fire").emitting = false
	await get_tree().create_timer(1.0).timeout
	TrailVfx.queue_free()


func fire_particle(particle: PackedScene):
	var particle_instance = particle.instantiate()
	particle_instance.transform.origin = transform.origin
	add_sibling(particle_instance)


func fire_oneshot_particle(scene: PackedScene, offset_y: float):
	var instance = scene.instantiate()
	add_sibling(instance)
	instance.global_position = Vector3(global_position.x, global_position.y+offset_y, global_position.z)


func update_shield_opacity(delta: float) -> void:
	var mat = shield_mesh.get_active_material(0)
	var goal_opacity = 0.5 if Globals.players_invincible else 0.0
	if mat and mat is StandardMaterial3D:
		shield_opacity = lerpf(shield_opacity, goal_opacity, delta*15)
		mat.albedo_color.a = shield_opacity


func emit_debris():
	left_debris.emit_debris()
	right_debris.emit_debris()
func stop_debris():
	left_debris.stop_debris()
	right_debris.stop_debris()


func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage()
