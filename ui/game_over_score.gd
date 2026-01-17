extends Label

func _ready() -> void:
	text = 'Your score was ' + str(Globals.score)
	print("GAME OVER HUD SPAWNED")
