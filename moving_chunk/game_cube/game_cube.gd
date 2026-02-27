extends Node3D

@onready var cube: Area3D = $Cube
@onready var score_particles: CPUParticles3D = $ScoreParticles

func _on_cube_cube_was_cleared(cube_ref) -> void:
	var score = 5
	if cube_ref.cleared_by_player == true:
		score = 100
		display_score(score)
	Globals.score += score

func _on_cube_cube_exploded() -> void:
	Globals.exploded_cube_effects()

func display_score(points: int):
	score_particles.mesh.text = str(points)
	score_particles.emitting = true
