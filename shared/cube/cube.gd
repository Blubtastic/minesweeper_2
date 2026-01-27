extends Area3D

const DAMAGE_AREA = preload("uid://ftokwp4ypb8m")
const CUBE_DESTROYED = preload("uid://bp6e0aywkls4b")

@export var isLoadingCleared: bool = false
@export var isLoadingExploded: bool = false
@onready var reveal_cube_audio: AudioStreamPlayer = $RevealCube
@onready var place_flag_audio: AudioStreamPlayer = $PlaceFlag
@onready var remove_flag_audio: AudioStreamPlayer = $RemoveFlag
@onready var explosion_audio: AudioStreamPlayer = $Explosion
@onready var nearby_mines_label: Label3D = $NearbyMinesLabel

@onready var cube_top: Node3D = $CubeTop
@onready var score_particle_big: CPUParticles3D = $ScoreParticleBig
@onready var score_particle_small: CPUParticles3D = $ScoreParticleSmall
@onready var sparks: GPUParticles3D = $Sparks

var is_bomb: bool = false
var has_exploded: bool = false
var is_cleared: bool = false
var nearby_cubes: Array[Node3D]
var has_given_points: bool = false

signal cube_was_cleared


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

func _ready():
	if isLoadingCleared:
		is_cleared = true
	if isLoadingExploded:
		is_bomb = true
		sparks.emitting = true
		reveal_cube(false)
		display_score(10)
		display_score_big(100)
		spawn_explosion()

func handle_uncleared_pressed():
		if !is_cleared and !is_bomb:
			give_points(100)
			sparks.emitting = true
			reveal_cube(true)
		if is_bomb:
			trigger_explosion()

func reveal_cube(play_sound: bool = false):
	if !is_cleared:
		if play_sound:
			reveal_cube_audio.play()
		give_points(10)
		cube_top.visible = false
		nearby_mines_label.visible = true
		is_cleared = true;
		cube_was_cleared.emit(self)
		update_cube()
		if is_bomb:
			pass # ground effect for exploded area

func trigger_explosion():
	if !has_exploded:
		explosion_audio.play()
		spawn_explosion()

func spawn_explosion():
	var CubeDestroyed = CUBE_DESTROYED.instantiate()
	add_child(CubeDestroyed)
	CubeDestroyed.global_position = Vector3(global_position.x, global_position.y + 0.7, global_position.z)
	cube_top.visible = false
	has_exploded = true
	
	var DamageArea = DAMAGE_AREA.instantiate()
	add_child(DamageArea)
	DamageArea.global_position = Vector3(global_position.x, global_position.y + 0.7, global_position.z)
	await get_tree().create_timer(1.0).timeout
	DamageArea.queue_free()

func give_points(points: int):
	if !has_given_points:
		has_given_points = true
		Globals.score += points
		if points > 10:
			display_score_big(points)
		else:
			display_score(points)

func display_score(points: int):
	score_particle_small.mesh.text = str(points)
	score_particle_small.emitting = true

func display_score_big(points: int):
	score_particle_big.mesh.text = str(points)
	score_particle_big.emitting = true


func update_cube() -> void:
	var overlapping_cubes: Array[Area3D] = get_overlapping_areas().filter(func(node): return node.has_method("reveal_cube"))
	var nearby_mines: int = get_nearby_cube_info(overlapping_cubes)
	
	if is_cleared:
		var nearby_mines_text := str(nearby_mines) if nearby_mines else ''
		var nearby_mines_color := COLORS[clamp(nearby_mines, 1, COLORS.size()) - 1]
		var text := '' if is_bomb else nearby_mines_text
		var color := Color(1, 1, 1) if is_bomb else nearby_mines_color
		update_label(text, color)
		if !nearby_mines:
			for overlapping_cube in overlapping_cubes:
				overlapping_cube.reveal_cube()

func get_nearby_cube_info(nearbyCubes: Array[Area3D]) -> int:
	var bombs := nearbyCubes.filter(func(nearbyCube): return nearbyCube.is_bomb)
	return bombs.size()

func update_label(text: String, color: Color) -> void:
	nearby_mines_label.text = text
	nearby_mines_label.modulate = color
	nearby_mines_label.outline_modulate = color
