extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var FPS = Engine.get_frames_per_second()
	text = str(floor(FPS))
