extends Node3D
const CubeChunk := preload("res://CubeChunk.tscn")

@onready var ray: RayCast3D = $Ray

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !ray.is_colliding():
		var chunk_instance = CubeChunk.instantiate()
		var chunk_position = Vector3(0.5, 0, 0)
		chunk_instance.transform.origin = chunk_position
		add_child(chunk_instance)
