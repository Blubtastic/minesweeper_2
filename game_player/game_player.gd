extends Node3D


const SPARKS := preload("uid://dvabslbqfwp0v")
const IMPACT_GRENADE := preload("uid://5s7j7ty55jtj")


@export_range(1,2) var player_id := 1
@onready var joystick: Control = $AnchorBottomLeft/Joystick
@onready var player: CharacterBody3D = $Player
@onready var colored_roof_1: MeshInstance3D = $Player/ColoredRoof1
@onready var colored_roof_2: MeshInstance3D = $Player/ColoredRoof2


func _ready() -> void:
	if player_id == 1:
		colored_roof_1.visible = true
	else:
		colored_roof_2.visible = true

	Globals.shared_hp_changed.connect(_on_shared_hp_changed)
	if player_id:
		player.player_id = player_id

	player.base_speed = Globals.player_speed
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	player.joystick_direction = dir
	player.speed_multiplier = speed


func _physics_process(_delta: float) -> void:
	player.external_speed = Globals.world_speed
	Globals.set_player_position(player_id, player.position)

	if Input.is_action_just_pressed("use_powerup_player" + str(player_id)):
		use_powerup()


func _on_player_is_flying_changed(is_flying: bool) -> void:
	if is_flying == true:
		Music.start_low_pass_filter()


func _on_player_was_damaged(current_hp: int) -> void:
	Globals.trigger_camera_jump()
	Globals.set_shared_hp(current_hp)
	Music.mute_drums(false)
	if current_hp == 1:
		Music.mute_tambourine(false)
	if current_hp == 0:
		Globals.end_game()
		despawn()


func _on_shared_hp_changed(new_hp: int) -> void:
	player.hp = new_hp


func despawn(delay: int = 2) -> void:
	await get_tree().create_timer(delay).timeout
	queue_free()


# Hardcoded to fire ImpactGrenade powerup
func use_powerup() -> void:
	var fire_position := Vector3(player.global_position.x, player.global_position.y-0.8, player.global_position.z-0.5)
	var impact_grenade_instance := IMPACT_GRENADE.instantiate()
	impact_grenade_instance.transform.origin = fire_position
	impact_grenade_instance.linear_velocity = Vector3(0, 2.5, -5)
	impact_grenade_instance.source = player
	add_child(impact_grenade_instance)
	
	var sparks_instance := SPARKS.instantiate()
	sparks_instance.transform.origin = fire_position
	sparks_instance.emitting = true
	add_sibling(sparks_instance)
