extends Node3D

@export var p: Player
const SPARKS := preload("uid://dvabslbqfwp0v")
@onready var bomb_powerup_mesh: Node3D = $Cannon


# Hardcoded to fire ImpactGrenade powerup
func use_powerup() -> void:
	if !p.available_powerup:
		return

	var fire_position := Vector3(p.global_position.x, p.global_position.y+0, p.global_position.z-0.5)
	var powerup_instance: Node = p.available_powerup.instantiate()
	powerup_instance.transform.origin = fire_position
	powerup_instance.linear_velocity = Vector3(0, 7.5, -4.5)
	powerup_instance.source = p
	powerup_instance.exploded.connect(Globals.trigger_camera_shake)
	get_tree().root.add_child(powerup_instance)
	p.set_available_powerup(null)
	bomb_powerup_mesh.visible = false

	var sparks_instance := SPARKS.instantiate()
	sparks_instance.transform.origin = fire_position
	sparks_instance.emitting = true
	get_tree().root.add_child(sparks_instance)


func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		p.set_available_powerup(area.powerup)
		area.pick_up()
		bomb_powerup_mesh.visible = true
