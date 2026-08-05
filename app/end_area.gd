extends Node3D

#const MoveWithGlobal = preload("uid://cdvo4jdy5fco4")
@onready var area_3d: Area3D = $Area3D
@onready var end_area_ui: Control = $EndAreaUI


## Moves the particle to match the world speed.
func _physics_process(delta: float) -> void:
	global_position.z += Globals.world_speed*delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		handle_finished_level()
		end_area_ui.visible = true
		end_area_ui.handle_game_over()
		Globals.level_over = true


func handle_finished_level() -> void:
	pass
	# UPDATE end_area_ui so it can display coins:
		# var rewards = Globals.get_rewards()

	# 0.1. MAKE GLOBAL VARS FOR ACE and 100%
	# 0.2. LOGIC FOR ACE (HAS PLAYER BEEN DAMAGED DURING LEVEL?)
	# 0.3. LOGIC FOR 100% (ARE CLEARED CUBES THE SAME AS ALL CUBES - MINES?)
