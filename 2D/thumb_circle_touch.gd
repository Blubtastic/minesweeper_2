extends TouchScreenButton

@onready var touch_screen_button: TouchScreenButton = $"."
@onready var debug_touch_point: Label = $"../DebugTouchPoint"

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		print("touch pressed / released")
		print(event.position)
	if event is InputEventScreenDrag:
		print("now dragging - position:")
		print(event.position)
		debug_touch_point.text = str(event.position)
	
	# TODO
	# create thumb-indicator (circle shape)
	# input-parameter for x/y position

	# get position of center-point from thumb-indicator
	# set thumb-indicator to position
	# clamp position to pythagoras from center-point
	
	# ignore input if too far from center-point
