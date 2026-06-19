extends Node3D

class_name Pickup

@export var rotation_speed: float = 10

func _physics_process(delta: float) -> void:
	# Rotate around the Y axis
	rotate_y(rotation_speed * delta)
