extends Node3D

const GAME_OVER = preload("uid://qhpvf7y1n474")
const CUBE_CHUNK = preload("uid://dgxv52jn27v3c")
const FOREST_CHUNK = preload("uid://dhlda46fqvnos")

@onready var ray: RayCast3D = $Ray
@onready var left_ray: RayCast3D = $LeftRay
@onready var right_ray: RayCast3D = $RightRay
@onready var cube_timer: Timer = $CubeTimer

func _ready():
	Globals.game_ended.connect(_on_game_ended)
	start_timer(3)

func _physics_process(_delta: float):
	if !left_ray.is_colliding():
		var forest_instance = FOREST_CHUNK.instantiate()
		var forest_position = Vector3(ray.transform.origin.x - 9, 0.5, ray.transform.origin.z - 3.945)
		forest_instance.transform.origin = forest_position
		add_child(forest_instance)
	if !right_ray.is_colliding():
		var forest_instance = FOREST_CHUNK.instantiate()
		var forest_position = Vector3(right_ray.transform.origin.x + 2, 0.5, right_ray.transform.origin.z - 3.945)
		forest_instance.transform.origin = forest_position
		add_child(forest_instance)
 
func _on_game_ended():
	var game_over_instance = GAME_OVER.instantiate()
	add_child(game_over_instance)

func start_timer(wait_time: float = 5.33):
	cube_timer.wait_time = wait_time
	cube_timer.one_shot = true
	cube_timer.start()
	await cube_timer.timeout
	spawn_cubechunk()
	start_timer()

func spawn_cubechunk():
	var chunk_instance = CUBE_CHUNK.instantiate()
	var chunk_position = Vector3(-4.5, 0, -20.85)
	chunk_instance.transform.origin = chunk_position
	add_child(chunk_instance)
