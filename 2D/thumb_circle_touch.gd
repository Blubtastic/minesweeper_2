extends Control

@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton
@onready var debug_touch_point: Label = $DebugTouchPoint
@onready var circle: Control = $Circle
@onready var follow_thumb: Polygon2D = $Circle/FollowThumb

var max_radius = 150

func _input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
		#print("touch pressed / released")
		#print(event.position)
	if event is InputEventScreenDrag:
		#print("now dragging - position:")
		#print(event.position)
		debug_touch_point.text = str(event.position)
		
		# create thumb-indicator (circle shape)
		# input-parameter for x/y position
		var center_position: Vector2 = circle.position
		# get position of center-point from thumb-indicator
		var thumb_position: Vector2 = event.position

		# clamp position to pythagoras from center-point
		# ignore input if too far from center-point
		var direction = center_position - thumb_position
		var distance = direction.length()
		if distance > max_radius:
			direction = direction.normalized() * max_radius
			follow_thumb.position = thumb_position - center_position + direction
			print(thumb_position - center_position + direction)
		else:
			# set thumb-indicator to position
			follow_thumb.position = thumb_position - center_position
			print(thumb_position - center_position)
		# TODO: fix issues with global vs local coordinates
