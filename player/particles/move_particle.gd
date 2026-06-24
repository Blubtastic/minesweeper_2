extends GPUParticles3D

func _ready() -> void:
	restart()

func _physics_process(delta: float) -> void:
	global_position.z += Globals.world_speed*delta
