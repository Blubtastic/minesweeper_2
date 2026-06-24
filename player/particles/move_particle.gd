extends GPUParticles3D

func _ready() -> void:
	restart()

## Moves the particle to match the world speed.
func _physics_process(delta: float) -> void:
	global_position.z += Globals.world_speed*delta
