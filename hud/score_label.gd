extends Label

func _physics_process(_delta: float) -> void:
	if !Globals.level_failed:
		text = str(Globals.score)
