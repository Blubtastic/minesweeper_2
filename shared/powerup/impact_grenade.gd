extends RigidBody3D

@export var source: Node


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)
