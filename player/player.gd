extends CharacterBody3D
class_name Player

@export_range(1,2) var id := 1
const START_HP: int = 3
@export var hp: int = START_HP
@onready var player_vfx := $PlayerVFX
@onready var player_powerups: Node3D = $PlayerPowerups
@onready var player_inputs: PlayerInputs = $PlayerInputs
var player_movement := PlayerMovement.new(self)
@onready var player_model: Node3D = $PlayerModel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var available_powerup: Node
var is_invincible := false
var is_grounded := false

func _ready() -> void:
	Globals.level_completed.connect(handle_level_completed)


func _physics_process(delta: float) -> void:
	Globals.set_player_position(id, position)
	var direction := Vector3.ZERO if Globals.is_level_over else player_inputs.get_direction()
	var speed_multiplier := player_inputs.get_speed_multiplier()
	player_movement.handle_base_movement(delta)
	player_movement.update_horizontal_movement(direction,speed_multiplier, delta)
	player_vfx.update_visuals(delta)
	player_vfx.handle_tire_debris(direction, hp)


func damage() -> void:
	if not is_invincible:
		Storage.a_player_has_been_damaged = true
		hp -= 1
		Music.mute_drums(false)
		if hp < 2:
			Music.mute_tambourine(false)
			player_model.change_state(1)
		if hp <= 0:
			Globals.handle_player_died()
			TimerHelper.call_after_time(self, self.queue_free, 2.0)
		if hp == 2:
			player_model.change_state(2)

	if not is_grounded:
		Globals.trigger_camera_jump()
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




# ==================== MISC ====================
func handle_level_completed() -> void:
	animation_player.play("jump_and_spin")


func set_available_powerup(powerup: Node) -> void:
	player_inputs.set_powerup_button_visibility(!!powerup)
	available_powerup = powerup


func _on_player_powerups_bulldozer_started(duration: float) -> void:
	make_player_invincible(duration)
	make_player_grounded(duration)


func make_player_invincible(duration: float) -> void:
	TimerHelper.true_for_time(self, "is_invincible", duration)

func make_player_grounded(duration: float) -> void:
	TimerHelper.true_for_time(self, "is_grounded", duration)
