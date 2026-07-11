extends Node3D

## Moves the particle to match the world speed.
func _physics_process(delta: float) -> void:
	global_position.z += Globals.world_speed*delta
