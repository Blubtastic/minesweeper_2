extends Node3D

const GAME_OVER = preload("uid://qhpvf7y1n474")
const CUBE_CHUNK = preload("uid://dgxv52jn27v3c")
const FOREST_CHUNK = preload("uid://dhlda46fqvnos")

@onready var cubechunk_timer: Timer = $CubechunkTimer

func _ready():
	Globals.game_ended.connect(_on_game_ended)
	spawn_chunk_in(3)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("restart"):
			Globals.reset_game()
			get_tree().reload_current_scene()

func _on_game_ended():
	var game_over_instance = GAME_OVER.instantiate()
	add_child(game_over_instance)

func spawn_chunk_in(wait_time: float = 5.33):
	cubechunk_timer.wait_time = wait_time
	cubechunk_timer.one_shot = true
	cubechunk_timer.start()
	await cubechunk_timer.timeout
	spawn_cubechunk()
	spawn_chunk_in()

func spawn_cubechunk():
	var chunk_instance = CUBE_CHUNK.instantiate()
	var chunk_position = Vector3(-4.5, 0, -20.85)
	chunk_instance.transform.origin = chunk_position
	add_child(chunk_instance)
	spawn_forest()

func spawn_forest():
	var forest_instance = FOREST_CHUNK.instantiate()
	var forest_position = Vector3(-9, 0.5,-17.42)
	forest_instance.transform.origin = forest_position
	add_child(forest_instance)
	
	var forest_instance2 = FOREST_CHUNK.instantiate()
	var forest_position2 = Vector3(9, 0.5, -17.42)
	forest_instance2.transform.origin = forest_position2
	add_child(forest_instance2)
