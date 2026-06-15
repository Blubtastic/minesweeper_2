extends RigidBody3D

@export var source: Node
@onready var clear_hitbox: Area3D = $ClearHitbox
var detected_cubes := []

func _on_area_3d_area_entered(_area: Area3D) -> void:
	detected_cubes = clear_hitbox.get_overlapping_areas().filter(
		func (cube: Area3D) -> bool: return cube.has_method("damage")
	)
	for cube: Area3D in detected_cubes:
		cube.damage(source)

	queue_free()
