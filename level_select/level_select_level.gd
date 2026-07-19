extends Area3D

@export var level: int = 1

signal was_hovered(position: Vector3, level: int)


func _on_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	was_hovered.emit(position, level)
