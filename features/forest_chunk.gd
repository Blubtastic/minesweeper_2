extends AnimatableBody3D

func _physics_process(delta):
	move_and_collide(Vector3(0, 0, Globals.world_speed*delta))
