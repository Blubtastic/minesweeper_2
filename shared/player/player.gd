extends CharacterBody3D

const SPEED = 5.0
const FORWARD_SPEED = 7.0
const BACKWARD_SPEED = 5.0
const JUMP_VELOCITY = 6
const DAMAGED_VELOCITY = 12
const TERMINAL_VELOCITY = 40

var invincible: bool = false
var health: int = 3
var external_speed: float = 0
var joystick_direction: Vector2 = Vector2(0,0)
var speed_intensity: float = 1

const TRAIL_VFX = preload("uid://drynt1383xlht")
@onready var cube_hitbox: Area3D = $CubeHitbox
@onready var poof: GPUParticles3D = $Poof
@onready var sparks: GPUParticles3D = $Sparks
@onready var left_debris: Node3D = $TireDebrisSnowLeft
@onready var right_debris: Node3D = $TireDebrisSnowRight

signal is_flying_changed(is_flying: bool)
signal was_damaged(current_health: int)

func _physics_process(delta: float) -> void:
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
			velocity.z = direction.z * BACKWARD_SPEED * speed_intensity + external_speed # read
		if direction.z < 0:
			velocity.z = direction.z * FORWARD_SPEED * speed_intensity + external_speed # read
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speed_intensity)
		velocity.z = move_toward(velocity.z, external_speed, SPEED * speed_intensity) # read
		stop_debris()
	rotation.z = -velocity.x / 30
	rotation.x = -velocity.z / 30
	move_and_slide()

func damage():
	if not invincible:
		health -= 1
		velocity.y = DAMAGED_VELOCITY if health > 0 else TERMINAL_VELOCITY
		was_damaged.emit(health)
		is_flying_changed.emit(true)
		invincible = true
		
		var TrailVfx = TRAIL_VFX.instantiate()
		add_child(TrailVfx)
		await get_tree().create_timer(1.0).timeout
		invincible = false
		is_flying_changed.emit(false)
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

func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()

func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage()
