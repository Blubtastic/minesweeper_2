extends GPUParticles3D

@export var speed: float = 0

func _ready():
	emitting = true
	self.finished.connect(_on_finished)

func _on_finished():
	queue_free()
