extends Node3D

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


func _on_player_is_flying_changed(is_flying: bool) -> void:
	if is_flying == true:
		Music.start_low_pass_filter()


func _on_player_was_damaged(current_hp: int) -> void:
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
