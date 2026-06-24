extends CharacterBody3D
class_name Player

@export_range(1,2) var id := 1
@export var hp: int = 3
@onready var player_vfx := $PlayerVFX
@onready var player_powerups: Node3D = $PlayerPowerups
@onready var joystick: Control = $TouchControls/AnchorBottomLeft/Joystick
var player_movement := PlayerMovement.new(self)
@onready var player_inputs: PlayerInputs = $PlayerInputs


func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	player_movement.joystick_direction = dir.normalized()
	player_movement.speed_multiplier = speed


func _ready() -> void:
	Globals.shared_hp_changed.connect(func(new_hp: int) -> void: hp = new_hp)
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _physics_process(delta: float) -> void:
	Globals.set_player_position(id, position)
	## Input setup could be moved to its own class.
	var input_dir := Input.get_vector(
		"move_left_player" + str(id),
		"move_right_player" + str(id),
		"move_up_player" + str(id),
		"move_down_player" + str(id),
	)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player_movement.handle_base_movement(delta)
	player_movement.update_horizontal_movement(direction, delta)
	player_vfx.update_visuals(delta)
	player_vfx.handle_tire_debris(direction, hp)


func damage() -> void:
	if not Globals.players_invincible:
		hp -= 1
		Globals.set_shared_hp(hp)
		Music.mute_drums(false)
		if hp < 2:
			Music.mute_tambourine(false)
		if hp <= 0:
			Globals.end_game()
			TimerHelper.call_after_time(self, queue_free, 2.0)

	Globals.trigger_camera_jump()
	TimerHelper.true_for_time(Globals, "players_invincible", 1.0)
	player_movement.launch_self_upwards(hp <= 0)
	player_vfx.start_damage_trail(1.5)
	Music.start_low_pass_filter()


# ==================== COLLISION SIGNALS ====================
func _on_damage_hitbox_area_entered(_area: Area3D) -> void:
	damage()


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)


# ==================== INPUT SIGNALS ====================
func _on_player_inputs_on_jump_pressed() -> void:
	if is_on_floor():
		player_movement.jump()
		player_vfx.fire_poof_below_player()


func _on_player_inputs_on_powerup_pressed() -> void:
	player_powerups.use_powerup()
