extends Node3D

@export var p: Player
const SPARKS := preload("uid://dvabslbqfwp0v")
@onready var bomb_powerup_mesh: Node3D = $Cannon
@onready var bulldozer_mesh: Node3D = $Bulldozer
var bulldozer_duration := 4.0
@onready var bulldozer_timer: Timer = $BulldozerTimer
@onready var blink_timer: Timer = $BlinkTimer
var blink_interval := 0.2

signal toggle_bulldozer_state(state: bool)

func _process(_delta: float) -> void:
	var time_left := bulldozer_timer.get_time_left()
	if time_left <= 1.0 and !bulldozer_timer.is_stopped():
		var blink_state: bool = fmod(time_left, blink_interval) < (blink_interval / 2.0)
		bulldozer_mesh.visible = blink_state


func use_powerup() -> void:
	if !p.available_powerup:
		return

	if p.available_powerup is Bulldozer:
		start_bulldozer(bulldozer_duration)
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


func start_bulldozer(duration: float) -> void:
	toggle_bulldozer_state.emit(true)
	p.set_available_powerup(null)
	bulldozer_mesh.visible = true
	bulldozer_timer.start(duration)


func _on_pickup_area_area_entered(area: Area3D) -> void:
	if area is Pickup:
		area.pick_up()
		p.set_available_powerup(area.powerup.instantiate())
		if p.available_powerup is ImpactGrenade:
			bomb_powerup_mesh.visible = true
		if p.available_powerup is Bulldozer:
			use_powerup()


func _on_bulldozer_timer_timeout() -> void:
	toggle_bulldozer_state.emit(false)
	bulldozer_mesh.visible = false
