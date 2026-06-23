extends Node3D


const SPARKS := preload("uid://dvabslbqfwp0v")

@export_range(1,2) var player_id := 1
@onready var joystick: Control = $AnchorBottomLeft/Joystick
@onready var player: Player = $Player
@onready var colored_roof_1: MeshInstance3D = $Player/ColoredRoof1
@onready var colored_roof_2: MeshInstance3D = $Player/ColoredRoof2
var available_powerup: PackedScene


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
	if !available_powerup:
		return

	var fire_position := Vector3(player.global_position.x, player.global_position.y-0.8, player.global_position.z-0.5)
	var powerup_instance := available_powerup.instantiate()
	powerup_instance.transform.origin = fire_position
	powerup_instance.linear_velocity = Vector3(0, 7.5, -4.5)
	powerup_instance.source = player
	powerup_instance.exploded.connect(Globals.trigger_camera_shake)
	add_child(powerup_instance)
	available_powerup = null

	var sparks_instance := SPARKS.instantiate()
	sparks_instance.transform.origin = fire_position
	sparks_instance.emitting = true
	add_child(sparks_instance)

func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		available_powerup = area.powerup
		print(area.powerup)
		area.pick_up()
