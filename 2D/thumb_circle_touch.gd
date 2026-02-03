extends TouchScreenButton

@onready var touch_screen_button: TouchScreenButton = $"."

# input anywhere on the screen
func _input(event: InputEvent) -> void:
	# every kind of input, even mouse movement
	if event is InputEventFromWindow:
		print("input")
		# touch input
		if event is InputEventScreenTouch:
			print("touch pressed")
			print(event.position)
			# might have to check if input is inside the TouchArea
