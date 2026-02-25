extends Node3D

@onready var joystick: Control = $AnchorBottomLeft/Joystick
@onready var player: CharacterBody3D = $Player

func _ready():
	Globals.player_hp = player.health
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)

func _on_joystick_moved(dir: Vector2, speed: float):
	player.joystick_direction = dir
	player.speed_intensity = speed

func _physics_process(_delta: float):
	player.external_speed = Globals.world_speed

func _on_player_is_flying_changed(is_flying: bool) -> void:
	if is_flying == true:
		Music.add_music_low_pass_filter()
	else:
		Music.remove_music_low_pass_filter()

func _on_player_was_damaged(current_health: int) -> void:
	Globals.player_hp = current_health
	Music.mute_drums(false)
	if current_health == 1:
		Music.mute_tambourine(false)
	if current_health == 0:
		Globals.end_game()
		despawn()

func despawn(delay: int = 2):
	await get_tree().create_timer(delay).timeout
	queue_free()
