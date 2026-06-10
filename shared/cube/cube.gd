extends Area3D

const COLORS: Array[Color] = [
	Color(0, 0, 1),
	Color(0, 0.5, 0),
	Color(1, 0, 0),
	Color(0, 0, 0.5),
	Color(0.3, 0.05, 0),
	Color(0, 0.4, 0.5),
	Color(0, 0, 0),
	Color(0.5, 0.5, 0.5)
]

const DESTROYED_CUBE = preload("uid://bp6e0aywkls4b")

@onready var sparks: GPUParticles3D = $Sparks
@onready var reveal_cube_audio: AudioStreamPlayer = $RevealCube
@onready var place_flag_audio: AudioStreamPlayer = $PlaceFlag
@onready var remove_flag_audio: AudioStreamPlayer = $RemoveFlag
@onready var explosion_audio: AudioStreamPlayer = $Explosion
@onready var pop: AudioStreamPlayer = $Pop

@onready var nearby_mines_label: Label3D = $NearbyMinesLabel
@onready var cube_top: Node3D = $CubeTop
@export var is_bomb: bool = false

var nearby_cubes: Array[Node3D]
var has_exploded: bool = false
var is_cleared: bool = false
var cleared_by_player: bool = false

signal cube_was_cleared
signal cube_exploded


func damage():
	if !is_cleared:
		cleared_by_player = true
		sparks.emitting = true
		reveal_cube_audio.play()
		if is_bomb:
			handle_siblings(3) # Clear all cubes in a 3 unit radius
			trigger_explosion()
		else:
			handle_siblings()


func reveal_self() -> void:
	if !is_cleared:
		is_cleared = true;
		cube_top.visible = false
		pop.play()
		nearby_mines_label.visible = true
		cube_was_cleared.emit(self)


# Setting a clear_radius will clear siblings in the radius, even if it's a mine.
func handle_siblings(clear_radius: int = -1):
	if clear_radius == -1 and is_cleared:
		return
	var overlapping_cubes: Array[Area3D] = get_overlapping_areas().filter(func(node): return node.has_method("handle_siblings"))
	var nearby_mines: int = get_nearby_cube_info(overlapping_cubes)
	set_cube_label(nearby_mines)
	reveal_self()
	clear_siblings(overlapping_cubes, nearby_mines, clear_radius)


func clear_siblings(overlapping_cubes: Array[Area3D], nearby_mines: int, clear_radius: int) -> void:
	if clear_radius == -1 and !nearby_mines:
		await get_tree().create_timer(0.05).timeout
		for overlapping_cube in overlapping_cubes:
			overlapping_cube.handle_siblings(-1)
	if clear_radius > 1:
		await get_tree().create_timer(0.04).timeout
		for overlapping_cube in overlapping_cubes:
			if (overlapping_cube.global_position.x == global_position.x
			or overlapping_cube.global_position.z == global_position.z):
				overlapping_cube.handle_siblings(clear_radius - 1)


func set_cube_label(nearby_mines: int) -> void:
	var nearby_mines_text := str(nearby_mines) if nearby_mines else ''
	var nearby_mines_color := COLORS[clamp(nearby_mines, 1, COLORS.size()) - 1]
	var text := 'X' if is_bomb else nearby_mines_text
	var color := Color(0,0,0) if is_bomb else nearby_mines_color
	update_label(text, color)

func update_label(text: String, color: Color) -> void:
	nearby_mines_label.text = text
	nearby_mines_label.modulate = color
	nearby_mines_label.outline_modulate = color


func get_nearby_cube_info(nearbyCubes: Array[Area3D]) -> int:
	var bombs := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_bomb)
	return bombs.size()


func trigger_explosion():
	if !has_exploded:
		cube_exploded.emit()
		explosion_audio.play()
		spawn_explosion()


func spawn_explosion():
	var destroyed_cube = DESTROYED_CUBE.instantiate()
	add_child(destroyed_cube)
	destroyed_cube.global_position = Vector3(global_position.x, global_position.y + 0.7, global_position.z)
	cube_top.visible = false
	has_exploded = true
