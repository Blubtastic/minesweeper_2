extends CharacterBody3D

const SPEED = 5.0
const FORWARD_SPEED = 7.0
const BACKWARD_SPEED = 5.0
const JUMP_VELOCITY = 6
const LAUNCH_VELOCITY = 12
var invincible: bool = false
var overlapping_cubes
var is_controllable = true
@onready var hitbox: Area3D = $Area3D
@onready var damage_hitbox: Area3D = $DamageHitbox

func _physics_process(delta: float) -> void:
	var cubes = get_tree().get_nodes_in_group("cubes")
	overlapping_cubes = hitbox.get_overlapping_bodies()
	for overlapping_cube in overlapping_cubes:
		if overlapping_cube in cubes:
			overlapping_cube.handle_uncleared_pressed()
	var overlapping_damage = damage_hitbox.get_overlapping_areas()
	if len(overlapping_damage) > 0:
		damage_player()

	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		if direction.z > 0:
			velocity.z = direction.z * BACKWARD_SPEED + Globals.world_speed
		if direction.z < 0:
			velocity.z = direction.z * FORWARD_SPEED + Globals.world_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, Globals.world_speed, SPEED)
	rotation.z = -velocity.x / 30
	rotation.x = -velocity.z / 10

	if is_controllable:
		move_and_slide()

func damage_player():
	if not invincible:
		velocity.y = LAUNCH_VELOCITY
		invincible = true
		await get_tree().create_timer(1.0).timeout
		invincible = false
