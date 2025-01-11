extends Node3D
const CubeChunk := preload("res://CubeChunk.tscn")
const ForestChunk := preload("res://features/ForestChunk.tscn")

@onready var ray: RayCast3D = $Ray
@onready var left_ray: RayCast3D = $LeftRay
@onready var right_ray: RayCast3D = $RightRay

func _physics_process(delta: float):
	if !ray.is_colliding():
		var chunk_instance = CubeChunk.instantiate()
		var chunk_position = Vector3(ray.transform.origin.x - 4.5, 0, ray.transform.origin.z - 7.3)
		chunk_instance.transform.origin = chunk_position
		add_child(chunk_instance)

	if !left_ray.is_colliding():
		var forest_instance = ForestChunk.instantiate()
		var forest_position = Vector3(ray.transform.origin.x - 9, 0.5, ray.transform.origin.z - 3.945)
		forest_instance.transform.origin = forest_position
		add_child(forest_instance)
	if !right_ray.is_colliding():
		var forest_instance = ForestChunk.instantiate()
		var forest_position = Vector3(right_ray.transform.origin.x + 2, 0.5, right_ray.transform.origin.z - 3.945)
		forest_instance.transform.origin = forest_position
		add_child(forest_instance)
