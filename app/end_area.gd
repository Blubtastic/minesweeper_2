extends Node3D

#const MoveWithGlobal = preload("uid://cdvo4jdy5fco4")
@onready var area_3d: Area3D = $Area3D
@onready var end_area_ui: Control = $EndAreaUI


## Moves the particle to match the world speed.
func _physics_process(delta: float) -> void:
	global_position.z += Globals.world_speed*delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		end_area_ui.visible = true
		end_area_ui.handle_game_over()
		Globals.is_level_over = true
		Globals.trigger_level_completed()
