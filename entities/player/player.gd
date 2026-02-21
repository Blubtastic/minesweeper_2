extends CharacterBody3D

const SPEED = 5.0
const FORWARD_SPEED = 7.0
const BACKWARD_SPEED = 5.0
const JUMP_VELOCITY = 6
const LAUNCH_VELOCITY = 12
const TERMINAL_VELOCITY = 40
var invincible: bool = false
var overlapping_cubes
var is_controllable = true
var joystick_direction: Vector2 = Vector2(0,0)
var speed_intensity: float = 1

const TRAIL_VFX = preload("uid://drynt1383xlht")
@onready var cube_hitbox: Area3D = $CubeHitbox
@onready var poof: GPUParticles3D = $Poof
@onready var sparks: GPUParticles3D = $Sparks
@onready var left_debris: Node3D = $TireDebrisSnowLeft
@onready var right_debris: Node3D = $TireDebrisSnowRight
@onready var joystick: Control = $"../Joysticky/Joystick"


func _ready():
	# set global player_hp to initial_hp
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)

func _on_joystick_moved(dir: Vector2, speed: float):
	joystick_direction = dir
	speed_intensity = speed

func _physics_process(delta: float) -> void:
	var cubes = get_tree().get_nodes_in_group("cubes")
	overlapping_cubes = cube_hitbox.get_overlapping_areas()
	for overlapping_cube in overlapping_cubes:
		if overlapping_cube in cubes:
			overlapping_cube.handle_uncleared_pressed()

	if not is_on_floor():
		velocity += get_gravity() * 2 * delta
	else:
		sparks.emitting = true

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		poof.restart()
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") + joystick_direction
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_intensity
		if is_on_floor():
			emit_debris()
		else:
			stop_debris()
		if direction.z > 0:
			velocity.z = direction.z * BACKWARD_SPEED * speed_intensity + Globals.world_speed # read
		if direction.z < 0:
			velocity.z = direction.z * FORWARD_SPEED * speed_intensity + Globals.world_speed # read
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speed_intensity)
		velocity.z = move_toward(velocity.z, Globals.world_speed, SPEED * speed_intensity) # read
		stop_debris()
	rotation.z = -velocity.x / 30
	rotation.x = -velocity.z / 30

	if is_controllable:
		move_and_slide()

func damage_player():
	if not invincible:
		if Globals.player_hp < 2: # write
			velocity.y = TERMINAL_VELOCITY
			despawn()
		else:
			velocity.y = LAUNCH_VELOCITY
		Globals.damage_player(1) # write
		invincible = true
		Globals.is_player_flying = true
		
		var TrailVfx = TRAIL_VFX.instantiate()
		add_child(TrailVfx)
		await get_tree().create_timer(1.0).timeout
		invincible = false
		Globals.is_player_flying = false # write
		await get_tree().create_timer(0.5).timeout
		TrailVfx.get_node("Smoke").emitting = false
		TrailVfx.get_node("Fire").emitting = false
		await get_tree().create_timer(1.0).timeout
		TrailVfx.queue_free()

func emit_debris():
	left_debris.emit_debris()
	right_debris.emit_debris()
func stop_debris():
	left_debris.stop_debris()
	right_debris.stop_debris()

func despawn(delay: int = 2):
	await get_tree().create_timer(delay).timeout
	queue_free()

func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage_player()
