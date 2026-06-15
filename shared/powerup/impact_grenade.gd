extends RigidBody3D

class_name ImpactGrenade

@export var source: Node
@onready var clear_hitbox: Area3D = $ClearHitbox
var impacted_cube: Area3D = null

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(source)
		impacted_cube = area

	var affected_cubes := clear_hitbox.get_overlapping_areas().filter(
		func (cube: Area3D) -> bool: return cube.has_method("damage") and cube != impacted_cube
	)
	for cube: Area3D in affected_cubes:
		cube.damage(self)

	queue_free()
