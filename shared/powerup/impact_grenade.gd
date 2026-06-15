extends RigidBody3D

class_name ImpactGrenade

@export var source: Node
@onready var damage_area: Area3D = $ClearHitbox
var impact_item: Area3D = null
var direct_hit := true

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("damage"):
		area.damage(self)
		impact_item = area
	direct_hit = false
	var affected_items := damage_area.get_overlapping_areas().filter(
		func (item: Area3D) -> bool: return item.has_method("damage") and item != impact_item
	)
	for item: Area3D in affected_items:
		item.damage(self)

	queue_free()
