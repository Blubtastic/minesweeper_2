extends Label

func _process(_delta: float):
	if !Globals.game_over:
		text = str(Globals.score)
