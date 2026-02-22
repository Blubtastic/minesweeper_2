extends GPUParticles3D

var is_moving: bool = false

func _ready():
	self.finished.connect(_on_finished)

func _physics_process(delta: float):
	if is_moving:
		global_position.z += Globals.world_speed*delta

func fire_once(fire_position: Vector3):
	restart()
	global_position = fire_position
	is_moving = true

func _on_finished():
	is_moving = false
