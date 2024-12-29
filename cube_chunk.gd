extends AnimatableBody3D

const CubeScene := preload("res://shared/cube/Cube.tscn")
const GRID_HEIGHT := 12
const GRID_WIDTH := 10
const NUMBER_OF_MINES := 6
const CUBE_DISTANCE := 1.0
var game_started: bool = false
var cubes = []

func _ready() -> void:
	randomize()
	spawn_grid()
	set_mines()

func _process(delta):
	move_and_collide(Vector3(0, 0, 0.07))

func spawn_grid():
	for h in range(GRID_WIDTH):
		for w in range(GRID_HEIGHT):
			var cube_instance = CubeScene.instantiate()
			var cube_position = Vector3(h * CUBE_DISTANCE, 0, w * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			add_child(cube_instance)
			cubes.append(cube_instance)
	cubes = cubes.filter(func(cube): return !(cube.isLoadingCleared or cube.isLoadingExploded))

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
