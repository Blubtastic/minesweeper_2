extends Node3D

@onready var cube: Area3D = $Cube


func _on_cube_cube_was_cleared(cube_ref: Cube) -> void:
	Globals.handle_cube_was_cleared(cube_ref)


func _on_cube_cube_exploded() -> void:
	Globals.trigger_camera_shake()
