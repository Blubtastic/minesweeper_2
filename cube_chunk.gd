extends AnimatableBody3D

const CubeScene := preload("res://shared/cube/Cube.tscn")
const GRID_HEIGHT := 6
const GRID_WIDTH := 10
@export var NUMBER_OF_MINES: int = 10
const CUBE_DISTANCE := 1.0
var game_started: bool = false
var cubes = []
var buffer_cubes = []

func _ready() -> void:
	randomize()
	spawn_grid()
	set_mines()

func _physics_process(delta):
	move_and_collide(Vector3(0, 0, Globals.world_speed*delta))

func spawn_grid():
	for w in range(GRID_WIDTH):
		for h in range(GRID_HEIGHT):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(w * CUBE_DISTANCE, 0, h * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			add_child(cube_instance)
			cubes.append(cube_instance)
	cubes = cubes.filter(func(cube): return !(cube.isLoadingCleared or cube.isLoadingExploded))
	spawn_buffer_row(GRID_HEIGHT)
	spawn_buffer_row(GRID_HEIGHT+1)

func spawn_buffer_row(row: int):
	for w in range(GRID_WIDTH):
		var cube_instance = CubeScene.instantiate()
		var cube_position = Vector3(w * CUBE_DISTANCE, 0, row * CUBE_DISTANCE)
		cube_instance.transform.origin = cube_position
		add_child(cube_instance)
		buffer_cubes.append(cube_instance)

func randomized_mines():
	var mine_list := []
	for i in range(NUMBER_OF_MINES):
		mine_list.append(true)
	var not_mine_list := []
	for i in range(GRID_WIDTH * GRID_HEIGHT - NUMBER_OF_MINES):
		not_mine_list.append(false)
	var fullList := mine_list + not_mine_list
	fullList.shuffle()
	return fullList

func set_mines():
	var mine_list = randomized_mines()
	for i in range(cubes.size()):
		cubes[i].is_bomb = mine_list[i]

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
