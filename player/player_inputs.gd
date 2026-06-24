extends Node
class_name PlayerInputs

@export_range(1,2) var id := 1
signal on_jump_pressed
signal on_powerup_pressed



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("jump_player" + str(id)):
			on_jump_pressed.emit()
		if event.is_action_pressed("use_powerup_player" + str(id)):
			on_powerup_pressed.emit()


#func _on_joystick_moved(dir: Vector2, speed: float) -> void:
	#player_movement.joystick_direction = dir.normalized()
	#player_movement.speed_multiplier = speed
#func _ready() -> void:
	#if joystick.visible:
		#joystick.joystick_moved.connect(_on_joystick_moved)
