extends Node3D


@export_range(1,2) var player_id := 1
@onready var player: Player = $Player
@onready var joystick: Control = $AnchorBottomLeft/Joystick
const SPARKS := preload("uid://dvabslbqfwp0v")
var available_powerup: PackedScene
@onready var bomb_powerup_mesh: Node3D = $Player/bomb


func _ready() -> void:
# ==================== JOYSTICK LOGIC ====================
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	player.joystick_direction = dir
	player.player_movement.speed_multiplier = speed


# ==================== POWERUP LOGIC ====================
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("use_powerup_player" + str(player_id)):
		use_powerup()


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
	bomb_powerup_mesh.visible = false

	var sparks_instance := SPARKS.instantiate()
	sparks_instance.transform.origin = fire_position
	sparks_instance.emitting = true
	add_child(sparks_instance)


func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		available_powerup = area.powerup
		area.pick_up()
		bomb_powerup_mesh.visible = true
