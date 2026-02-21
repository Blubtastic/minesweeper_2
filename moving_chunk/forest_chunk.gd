extends AnimatableBody3D

func _physics_process(delta):
	move_and_collide(Vector3(0, 0, Globals.world_speed*delta))

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
