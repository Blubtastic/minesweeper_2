extends Area3D
class_name LevelSelectLevel

@onready var level_name: Label3D = $LevelName
@export var group: int = 1
@export var level: int = 1

@export var left: Area3D
@export var right: Area3D
@export var up: Area3D
@export var down: Area3D

signal was_hovered(position: Vector3, level: int)


func _ready() -> void:
	level_name.text = str(group) + "-" + str(level)


# HANDLE LEFT CLICK
func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	was_hovered.emit(position, level)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Globals.current_level = level
		get_tree().change_scene_to_file('res://levels/level_' + str(int(level)) + '.tscn')


# HANDLE VISUAL FOCUS
func grab_focus() -> void:
	$FocusMesh.visible = true


func release_focus() -> void:
	$FocusMesh.visible = false
