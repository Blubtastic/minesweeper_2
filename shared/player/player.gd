extends CharacterBody3D

const SPEED = 5.0
const FORWARD_SPEED = 7.0
const BACKWARD_SPEED = 5.0
const JUMP_VELOCITY = 6
const LAUNCH_VELOCITY = 12
var invincible: bool = false
var overlapping_cubes
var is_controllable = true

const TRAIL_VFX = preload("uid://drynt1383xlht")
@onready var cube_hitbox: Area3D = $CubeHitbox
@onready var damage_hitbox: Area3D = $DamageHitbox
@onready var player_shadow: Sprite3D = $"../PlayerShadow"
@onready var shadow_ray_cast: RayCast3D = $"../ShadowRayCast"
@onready var body: MeshInstance3D = $PlayerModel/Body
@onready var glow_animation_player: AnimationPlayer = $GlowAnimationPlayer
@onready var poof: GPUParticles3D = $Poof
@onready var sparks: GPUParticles3D = $Sparks
@onready var left_debris: Node3D = $TireDebrisSnowLeft
@onready var right_debris: Node3D = $TireDebrisSnowRight


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
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		if is_on_floor():
			emit_debris()
		else:
			stop_debris()
		if direction.z > 0:
			velocity.z = direction.z * BACKWARD_SPEED + Globals.world_speed
		if direction.z < 0:
			velocity.z = direction.z * FORWARD_SPEED + Globals.world_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, Globals.world_speed, SPEED)
		stop_debris()
	rotation.z = -velocity.x / 30
	rotation.x = -velocity.z / 30

	if is_controllable:
		move_and_slide()
	
	move_shadow()

func damage_player():
	if not invincible:
		Globals.player_hp -= 1
		glow_animation_player.play("new_animation")
		velocity.y = LAUNCH_VELOCITY
		invincible = true
		Globals.is_player_flying = true
		
		var TrailVfx = TRAIL_VFX.instantiate()
		add_child(TrailVfx)
		await get_tree().create_timer(1.0).timeout
		invincible = false
		Globals.is_player_flying = false
		await get_tree().create_timer(0.5).timeout
		TrailVfx.get_node("Smoke").emitting = false
		TrailVfx.get_node("Fire").emitting = false
		await get_tree().create_timer(1.0).timeout
		TrailVfx.queue_free()

func _on_cube_hitbox_area_entered(_area: Area3D) -> void:
	#damage_player()
	pass

func move_shadow():
	if shadow_ray_cast.is_colliding():
		var collision_point = shadow_ray_cast.get_collision_point()
		collision_point.x = global_position.x
		collision_point.y += 0.2
		collision_point.z = global_position.z
		player_shadow.global_transform.origin = collision_point

func emit_debris():
	left_debris.emit_debris()
	right_debris.emit_debris()
func stop_debris():
	left_debris.stop_debris()
	right_debris.stop_debris()

func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage_player()
