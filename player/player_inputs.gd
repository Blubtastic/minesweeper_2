extends Node
class_name PlayerInputs

@export var p: Player
@onready var joystick: Control = $TouchControls/AnchorBottomLeft/Joystick
var joystick_direction: Vector2 = Vector2.ZERO  # Joystick input accumulator
var speed_multiplier: float = 1.0  # Current speed intensity (0-1 range)

signal on_jump_pressed
signal on_powerup_pressed


func _ready() -> void:
	if joystick.visible:
		joystick.joystick_moved.connect(_on_joystick_moved)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("jump_player" + str(p.id)):
			on_jump_pressed.emit()
		if event.is_action_pressed("use_powerup_player" + str(p.id)):
			on_powerup_pressed.emit()


func get_direction() -> Vector3:
	var input_dir := Input.get_vector(
		"move_left_player" + str(p.id),
		"move_right_player" + str(p.id),
		"move_up_player" + str(p.id),
		"move_down_player" + str(p.id),
	)
	var direction := (p.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return Vector3(direction.x + joystick_direction.x, direction.y, direction.z + joystick_direction.y)


func get_speed_multiplier() -> float:
	return speed_multiplier


# ==================== INPUT SIGNALS ====================
func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	joystick_direction = dir.normalized()
	speed_multiplier = speed
