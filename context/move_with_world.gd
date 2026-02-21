extends Node3D

func _physics_process(delta: float):
	var items_to_move = get_tree().get_nodes_in_group("move_with_world")
	for item in items_to_move:
		if item.global_position:
			item.global_position += Vector3(0, 0, delta*Globals.world_speed)
