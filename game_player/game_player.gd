extends Node3D

@export var inputs: Dictionary[String, String]
@export var player_num: int = 1

@onready var joystick: Control = $AnchorBottomLeft/Joystick
@onready var player: CharacterBody3D = $Player


func _ready():
	Globals.shared_hp_changed.connect(_on_shared_hp_changed)
	if inputs:
		player.inputs = inputs
	
	player.speed = Globals.player_speed
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _on_joystick_moved(dir: Vector2, speed: float):
	player.joystick_direction = dir
	player.speed_intensity = speed


func _physics_process(_delta: float):
	player.external_speed = Globals.world_speed
	Globals.set_player_position(player_num, player.position)


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


func _on_shared_hp_changed(new_hp: int):
	player.hp = new_hp
	print(new_hp)

func despawn(delay: int = 2):
	await get_tree().create_timer(delay).timeout
	queue_free()
