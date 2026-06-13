extends Node3D

@onready var cube: Area3D = $Cube
@onready var score_particles: CPUParticles3D = $ScoreParticles


func _on_cube_cube_was_cleared(cube_ref: Cube) -> void:
	var score := 5
	if cube_ref.cleared_by is Player:
		score = 100
		display_score(score)
	Globals.handle_cube_cleared(score)


func _on_cube_cube_exploded() -> void:
	Globals.trigger_camera_shake()


func display_score(amount: int) -> void:
	score_particles.mesh.text = str(amount)
	score_particles.emitting = true
