extends Button

@export var button_text: String

func _ready():
	if button_text:
		text = button_text
