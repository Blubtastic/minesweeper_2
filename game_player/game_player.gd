extends Node3D

@onready var joystick: Control = $AnchorBottomLeft/Joystick
@onready var player: CharacterBody3D = $Player

func _ready():
	# set global player_hp to initial_hp
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)

func _on_joystick_moved(dir: Vector2, speed: float):
	player.joystick_direction = dir
	player.speed_intensity = speed
