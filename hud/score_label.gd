extends Label

func _physics_process(_delta: float) -> void:
	if !Globals.game_over:
		text = str(Globals.score)
