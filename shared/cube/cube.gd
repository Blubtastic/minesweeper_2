extends StaticBody3D
@onready var damage_area = preload("res://shared/DamageArea.tscn")
@onready var cube_destroyed = preload("res://shared/cube/CubeDestroyed.tscn")

@export var isLoadingCleared: bool = false
@export var isLoadingExploded: bool = false
@onready var reveal_cube_audio: AudioStreamPlayer = $RevealCube
@onready var place_flag_audio: AudioStreamPlayer = $PlaceFlag
@onready var remove_flag_audio: AudioStreamPlayer = $RemoveFlag
@onready var explosion_audio: AudioStreamPlayer = $Explosion
@onready var cube_scanner: Area3D = $CubeScanner
@onready var nearby_mines_label: Label3D = $NearbyMinesLabel
@onready var mine_sprite: Sprite3D = $Node3D/Mine

@onready var flag_sprite: Sprite3D = $Flag
@onready var top_mesh: MeshInstance3D = $TopMesh
@onready var score_particle_big: CPUParticles3D = $ScoreParticleBig
@onready var score_particle_small: CPUParticles3D = $ScoreParticleSmall
@onready var sparks: GPUParticles3D = $Sparks

var is_bomb: bool = false
var has_exploded: bool = false
var is_cleared: bool = false
var nearby_cubes: Array[Node3D]
var has_given_points: bool = false

signal cube_was_cleared

func _ready():
	if isLoadingCleared:
		is_cleared = true
	if isLoadingExploded:
		is_bomb = true
		handle_uncleared_pressed()

func handle_uncleared_pressed():
		if !is_cleared and !is_bomb:
			give_points(100)
			sparks.emitting = true
			
		reveal_cube(true)
		top_mesh.unhighlight_cube()
		if is_bomb:
			trigger_explosion()

func reveal_cube(play_sound: bool = false):
	if !is_cleared:
		if play_sound:
			reveal_cube_audio.play()
	
		give_points(10)
		top_mesh.visible = false
		nearby_mines_label.visible = true
		is_cleared = true;
		cube_was_cleared.emit(self)
		cube_scanner.update_cube()
		if is_bomb:
			mine_sprite.visible = true

func trigger_explosion():
	if !has_exploded:
		$Mesh.visible = false
		$Node3D/Stains.visible = true
		mine_sprite.visible = true
		#mine_sprite.transform = mine_sprite.transform.translated(Vector3(0, -1, 0))
		explosion_audio.play()
		var CubeDestroyed = cube_destroyed.instantiate()
		add_child(CubeDestroyed)
		CubeDestroyed.global_position = Vector3(global_position.x, global_position.y + 0.7, global_position.z)
		top_mesh.visible = false
		flag_sprite.visible = false
		has_exploded = true
		
		var DamageArea = damage_area.instantiate()
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
