extends Node3D
const CubeChunk := preload("res://CubeChunk.tscn")

@onready var ray: RayCast3D = $Ray

func _physics_process(delta: float):
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if !ray.is_colliding():
		var chunk_instance = CubeChunk.instantiate()
		var chunk_position = Vector3(ray.transform.origin.x - 4.5, 0, ray.transform.origin.z + -7.3)
		chunk_instance.transform.origin = chunk_position
		add_child(chunk_instance)
