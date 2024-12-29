extends Node3D
const CubeChunk := preload("res://CubeChunk.tscn")

@onready var ray: RayCast3D = $Ray

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()

func _physics_process(delta: float):
	if !ray.is_colliding():
		var chunk_instance = CubeChunk.instantiate()
		var chunk_position = Vector3(ray.transform.origin.x - 4.5, 0, ray.transform.origin.z + -11.5)
		chunk_instance.transform.origin = chunk_position
		add_child(chunk_instance)
