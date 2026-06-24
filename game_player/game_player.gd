extends Node3D


@export_range(1,2) var id := 1
@onready var player: Player = $Player
@onready var joystick: Control = $AnchorBottomLeft/Joystick


func _ready() -> void:
# ==================== JOYSTICK LOGIC ====================
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	player.joystick_direction = dir
	player.player_movement.speed_multiplier = speed
