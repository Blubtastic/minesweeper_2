extends Node3D

@export var p: Player
const SPARKS := preload("uid://dvabslbqfwp0v")
@onready var bomb_powerup_mesh: Node3D = $Cannon
@onready var bulldozer_mesh: Node3D = $Bulldozer


# Hardcoded to fire ImpactGrenade powerup
func use_powerup() -> void:
	if !p.available_powerup:
		return

	if p.available_powerup is Bulldozer:
		start_bulldozer(5)
	if p.available_powerup is ImpactGrenade:
		var fire_position := Vector3(p.global_position.x, p.global_position.y+0.25, p.global_position.z-0.5)
		p.available_powerup.transform.origin = fire_position
		p.available_powerup.linear_velocity = Vector3(0, 7.5, -4.5)
		p.available_powerup.source = p
		p.available_powerup.exploded.connect(Globals.trigger_camera_shake)
		get_tree().root.add_child(p.available_powerup)
		bomb_powerup_mesh.visible = false

		var sparks_instance := SPARKS.instantiate()
		sparks_instance.transform.origin = fire_position
		sparks_instance.emitting = true
		get_tree().root.add_child(sparks_instance)
		p.set_available_powerup(null)


func start_bulldozer(_duration: float) -> void:
	p.set_available_powerup(null)
	await TimerHelper.true_for_time(bulldozer_mesh, "visible", 3)
	blink_bulldozer_mesh(10, 0.1)


func blink_bulldozer_mesh(amount: int, duration: float) -> void:
	var blink_state := true
	for i in amount:
		await get_tree().create_timer(duration).timeout
		bulldozer_mesh.visible = blink_state
		blink_state = !blink_state


func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		area.pick_up()
		p.set_available_powerup(area.powerup.instantiate())
		if p.available_powerup is ImpactGrenade:
			bomb_powerup_mesh.visible = true
		if p.available_powerup is Bulldozer:
			use_powerup()
