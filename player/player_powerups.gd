extends Node3D

@export var p: Player
const SPARKS := preload("uid://dvabslbqfwp0v")
@onready var bomb_powerup_mesh: Node3D = $Cannon
@onready var bulldozer_mesh: Node3D = $Bulldozer


# Hardcoded to fire ImpactGrenade powerup
func use_powerup() -> void:
	if !p.available_powerup:
		return
	
	var powerup_instance: Node = p.available_powerup.instantiate()
	if powerup_instance is Bulldozer:
		start_bulldozer(5)
	else:
		var fire_position := Vector3(p.global_position.x, p.global_position.y+0.25, p.global_position.z-0.5)
		powerup_instance.transform.origin = fire_position
		powerup_instance.linear_velocity = Vector3(0, 7.5, -4.5)
		powerup_instance.source = p
		powerup_instance.exploded.connect(Globals.trigger_camera_shake)
		get_tree().root.add_child(powerup_instance)
		bomb_powerup_mesh.visible = false

		var sparks_instance := SPARKS.instantiate()
		sparks_instance.transform.origin = fire_position
		sparks_instance.emitting = true
		get_tree().root.add_child(sparks_instance)
	p.set_available_powerup(null)


func start_bulldozer(_duration: float) -> void:
	print("Bulldozer enabled!!")


func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		p.set_available_powerup(area.powerup)
		area.pick_up()
		bomb_powerup_mesh.visible = true
