extends RigidBody3D
class_name ImpactGrenade


@onready var animate_bomb: AnimationPlayer = $AnimateBomb
@onready var indicator: Node3D = $ClearHitbox/indicator
@onready var damage_area: Area3D = $ClearHitbox

@export var source: Node
var impact_item: Area3D = null
var direct_hit := true

signal exploded

func _on_area_3d_area_entered(area: Area3D) -> void:
	exploded.emit()
	if area.has_method("damage"):
		area.damage(self)
		impact_item = area
	direct_hit = false
	var affected_items := damage_area.get_overlapping_areas().filter(
		func (item: Area3D) -> bool: return item.has_method("damage") and item != impact_item
	)
	for item: Area3D in affected_items:
		item.damage(self)

	animate_bomb.play("despawn_bomb")
	await animate_bomb.animation_finished

	queue_free()


func _ready() -> void:
	indicator.global_position = Vector3(position.x, 0.7, position.z)


func _physics_process(_delta: float) -> void:
	if !impact_item:
		indicator.global_rotation_degrees = Vector3.UP
		indicator.global_position = Vector3(position.x, 0.7, position.z)
