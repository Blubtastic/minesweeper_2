extends GPUParticles3D

@export var fire_instantly := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if fire_instantly:
		emitting = true
