extends Node3D


# ==================== VISUALS ====================
const DEBRIS_PARTICLE_OFFSET_Y = -0.16
const SHIELD_OPACITY_GOAL_ACTIVE = 0.5
const SHIELD_OPACITY_GOAL_INACTIVE = 0.0
const SHIELD_OPACITY_LERP_SPEED = 15.0
const TRAIL_DURATION = 1.0
const TRAIL_FADE_DURATION = 1.0
var shield_opacity: float = 0.0  # Current shield visual opacity
var is_on_floor: bool = true

const POOF = preload("uid://bqxows5t0aoxo")
const SPARKS = preload("uid://j55l10fhpgty")
const TRAIL = preload("uid://drynt1383xlht")
@onready var left_debris: Node3D = $LeftDebris
@onready var right_debris: Node3D = $RightDebris
@onready var shield_mesh: MeshInstance3D = $ShieldMesh
@export var p: Player


func start_damage_trail(duration: float = 1.0) -> void:
	spawn_damage_trail()
	await get_tree().create_timer(duration).timeout
	cleanup_damage_trail()


func spawn_damage_trail() -> void:
	var trail_vfx := TRAIL.instantiate()
	add_child(trail_vfx)
	trail_vfx.name = "DamageTrailVFX"


func cleanup_damage_trail() -> void:
	await get_tree().create_timer(TRAIL_DURATION).timeout
	var trail_vfx := get_node_or_null("DamageTrailVFX")
	if not trail_vfx:
		return

	trail_vfx.get_node("Smoke").emitting = false
	trail_vfx.get_node("Fire").emitting = false

	await get_tree().create_timer(TRAIL_FADE_DURATION).timeout
	trail_vfx.queue_free()


func update_visuals(delta: float) -> void:
	update_collision_particles()
	update_shield_visual(delta)


func update_shield_visual(delta: float) -> void:
	var mat := shield_mesh.get_active_material(0)
	if not mat or not mat is StandardMaterial3D:
		return

	var goal_opacity := SHIELD_OPACITY_GOAL_ACTIVE if Globals.players_invincible else SHIELD_OPACITY_GOAL_INACTIVE
	shield_opacity = lerpf(shield_opacity, goal_opacity, delta * SHIELD_OPACITY_LERP_SPEED)
	mat.albedo_color.a = shield_opacity


func update_collision_particles() -> void:
	if !is_on_floor and p.is_on_floor():
		var instance := SPARKS.instantiate()
		get_tree().root.add_child(instance)
		instance.global_position = Vector3(p.global_position.x, p.global_position.y -0.16, p.global_position.z)
	is_on_floor = p.is_on_floor()


func fire_poof_below_player() -> void:
	var poof_instance := POOF.instantiate()
	get_tree().root.add_child(poof_instance)
	poof_instance.emitting = true
	poof_instance.global_position = Vector3(p.global_position.x, p.global_position.y -0.16, p.global_position.z)


func handle_tire_debris(direction: Vector3, hp: int) -> void:
	if direction and hp > 0:
		update_debris(p.is_on_floor())
	else:
		update_debris(false)

func update_debris(should_emit: bool) -> void:
	if should_emit:
		left_debris.emit_debris()
		right_debris.emit_debris()
	else:
		left_debris.stop_debris()
		right_debris.stop_debris()
