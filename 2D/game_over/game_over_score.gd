extends Label

func _ready() -> void:
	text = 'Your score is ' + str(Globals.score)
