extends Area3D

@export var group: int = 1
@export var level: int = 1
@onready var level_name: Label3D = $LevelName

signal was_hovered(position: Vector3, level: int)


func _ready() -> void:
	level_name.text = str(group) + "-" + str(level)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	was_hovered.emit(position, level)

	# LEVEL SELECT (on left click)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Globals.current_level = level
		get_tree().change_scene_to_file('res://levels/level_' + str(int(level)) + '.tscn')
