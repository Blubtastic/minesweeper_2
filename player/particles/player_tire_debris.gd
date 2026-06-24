extends Node3D
@onready var snow: GPUParticles3D = $Snow
@onready var smoke: GPUParticles3D = $Smoke

func emit_debris() -> void:
	snow.emitting = true
	smoke.emitting = true
func stop_debris() -> void:
	snow.emitting = false
	smoke.emitting = false
