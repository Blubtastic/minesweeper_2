extends AnimatableBody3D

const CUBE = preload("uid://cnor6jdbe28rj")
const CUBE_CHUNK = preload("uid://dgxv52jn27v3c")
const FOREST_CHUNK = preload("uid://dhlda46fqvnos")
const END_AREA = preload("uid://pb5upwfhqj54")
const PICKUP = preload("uid://cshkipadmqt3c")

@export var chunks_to_spawn: int = 5
var has_spawned_next: bool = false

@export var number_of_mines: int = 10
const GRID_HEIGHT := 6
const GRID_WIDTH := 10
const CUBE_DISTANCE := 1.0
var cubes := []
var buffer_cubes := []


func increase_global_clearable_cubes() -> void:
	const MAIN_GRID_COUNT: int = GRID_HEIGHT * GRID_WIDTH
	const BUFFER_COUNT: int = GRID_WIDTH * 2
	var clearable: int = MAIN_GRID_COUNT + BUFFER_COUNT - number_of_mines
	Storage.increase_clearable_cubes(clearable)


func _ready() -> void:
	if chunks_to_spawn > 0:
		randomize()
		spawn_grid()
		set_mines()
		spawn_powerups(0.2)
		TimerHelper.call_after_time(self, increase_global_clearable_cubes, 0.2)
	else:
		has_spawned_next = true


func _physics_process(delta: float) -> void:
	move_and_collide(Vector3(0, 0, Globals.world_speed*delta))
	if global_position.z > -15:
		if not has_spawned_next:
			has_spawned_next = true
			spawn_next_chunk()


func spawn_grid() -> void:
	for w in range(GRID_WIDTH):
		for h in range(GRID_HEIGHT):
			var cube_instance := CUBE.instantiate()
			var cube_position := Vector3(w * CUBE_DISTANCE, 0, h * CUBE_DISTANCE)
			cube_instance.transform.origin = cube_position
			add_child(cube_instance)

			cube_instance.cube_was_cleared.connect(func(ref: Node3D) -> void: Globals.handle_cube_was_cleared(ref))
			cube_instance.cube_exploded.connect(func() -> void: Globals.trigger_camera_shake())
			cubes.append(cube_instance)

	spawn_buffer_row(GRID_HEIGHT)
	spawn_buffer_row(GRID_HEIGHT+1)


func spawn_buffer_row(row: int) -> void:
	for w in range(GRID_WIDTH):
		var cube_instance := CUBE.instantiate()
		var cube_position := Vector3(w * CUBE_DISTANCE, 0, row * CUBE_DISTANCE)
		cube_instance.transform.origin = cube_position
		add_child(cube_instance)
		cube_instance.cube_was_cleared.connect(func(ref: Node3D) -> void: Globals.handle_cube_was_cleared(ref))
		cube_instance.cube_exploded.connect(func() -> void: Globals.trigger_camera_shake())
		buffer_cubes.append(cube_instance)


func randomized_mines() -> Array:
	var mine_list := []
	for i in range(number_of_mines):
		mine_list.append(true)
	var not_mine_list := []
	for i in range(GRID_WIDTH * GRID_HEIGHT - number_of_mines):
		not_mine_list.append(false)
	var fullList := mine_list + not_mine_list
	fullList.shuffle()
	return fullList


func set_mines() -> void:
	var mine_list := randomized_mines()
	for i in range(cubes.size()):
		cubes[i].is_bomb = mine_list[i]


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if has_spawned_next == true:
		queue_free()


func spawn_next_chunk() -> void:
	var next_remaining_chunks: int = chunks_to_spawn - 1
	if next_remaining_chunks > 0:
		var chunk_instance := CUBE_CHUNK.instantiate()
		var chunk_position := Vector3(-4.5, 0, global_position.z - 7.99)
		chunk_instance.transform.origin = chunk_position
		chunk_instance.chunks_to_spawn = next_remaining_chunks
		add_sibling(chunk_instance)
		spawn_forest()
	else:
		spawn_end_chunk()


func spawn_forest() -> void:
	var forest_instance := FOREST_CHUNK.instantiate()
	var forest_position := Vector3(-9, 0.57, global_position.z - 4.49)
	forest_instance.transform.origin = forest_position
	add_sibling(forest_instance)


func spawn_powerups(chance: float) -> void:
	var rng := RandomNumberGenerator.new()
	var random_number := rng.randf_range(0.0, 1.0)
	if random_number > chance:
		return

	var instance := PICKUP.instantiate()
	var rand_x := rng.randi_range(0, GRID_WIDTH-1)
	var rand_z := rng.randi_range(0, GRID_HEIGHT-1)
	instance.transform.origin = Vector3(rand_x * CUBE_DISTANCE, 1.0, rand_z * CUBE_DISTANCE)
	add_child(instance)


func spawn_end_chunk() -> void:
	spawn_forest()
	var end_instance := END_AREA.instantiate()
	var end_position := Vector3(-9, 0.57, global_position.z - 4.49)
	end_instance.transform.origin = end_position
	add_sibling(end_instance)
