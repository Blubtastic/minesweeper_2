extends Label

func _physics_process(_delta: float) -> void:
	if !Globals.is_level_failed:
		text = str(Globals.score)
