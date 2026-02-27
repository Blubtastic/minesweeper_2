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
	if !is_cleared and !is_bomb:
		cleared_by_player = true
		sparks.emitting = true
		reveal_cube(true)
	if is_bomb:
		trigger_explosion()

func reveal_cube(play_sound: bool = false):
	if !is_cleared:
		if play_sound:
			reveal_cube_audio.play()
		cube_top.visible = false
		pop.play()
		nearby_mines_label.visible = true
		is_cleared = true;
		cube_was_cleared.emit(self)
		update_cube()
		if is_bomb:
			pass # ground effect for exploded area

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

func update_cube() -> void:
	var overlapping_cubes: Array[Area3D] = get_overlapping_areas().filter(func(node): return node.has_method("reveal_cube"))
	var nearby_mines: int = get_nearby_cube_info(overlapping_cubes)
	
	if is_cleared:
		var nearby_mines_text := str(nearby_mines) if nearby_mines else ''
		var nearby_mines_color := COLORS[clamp(nearby_mines, 1, COLORS.size()) - 1]
		var text := '' if is_bomb else nearby_mines_text
		var color := Color(1, 1, 1) if is_bomb else nearby_mines_color
		update_label(text, color)
		await get_tree().create_timer(0.05).timeout
		if !nearby_mines:
			for overlapping_cube in overlapping_cubes:
				if overlapping_cube:
					overlapping_cube.reveal_cube()

func get_nearby_cube_info(nearbyCubes: Array[Area3D]) -> int:
	var bombs := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_bomb)
	return bombs.size()

func update_label(text: String, color: Color) -> void:
	nearby_mines_label.text = text
	nearby_mines_label.modulate = color
	nearby_mines_label.outline_modulate = color
