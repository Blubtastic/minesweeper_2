extends Area3D

@export var level: int = 1

signal was_hovered(position: Vector3, level: int)


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	was_hovered.emit(position, level)

	# LEVEL SELECT (on left click)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Globals.current_level = level
		get_tree().change_scene_to_file('res://levels/level_' + str(int(level)) + '.tscn')
