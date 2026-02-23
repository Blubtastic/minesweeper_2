extends GPUParticles3D

func _ready():
	restart()

func _physics_process(delta: float):
	global_position.z += Globals.world_speed*delta
