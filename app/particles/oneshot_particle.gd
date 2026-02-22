extends GPUParticles3D

var start_moving: bool = false

func _ready():
	self.finished.connect(_on_finished)

func _physics_process(delta: float):
	if start_moving:
		global_position.z += Globals.world_speed*delta

func fire_once(fire_position: Vector3):
	restart()
	start_moving = true
	global_position = fire_position

func _on_finished():
	start_moving = false
