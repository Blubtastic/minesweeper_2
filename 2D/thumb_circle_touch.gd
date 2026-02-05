extends Control

@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton
@onready var debug_touch_point: Label = $DebugTouchPoint
@onready var circle: Control = $Circle
@onready var thumb_icon: Polygon2D = $Circle/ThumbIcon

@export var max_radius = 150

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		debug_touch_point.text = str(event.position)
		move_thumb_icon(event)

func move_thumb_icon(event: InputEventScreenDrag):
	var center: Vector2 = circle.global_position
	var thumb: Vector2 = event.position

	var direction = center - thumb
	var distance = direction.length()
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		var final_position = -direction
		thumb_icon.position = final_position
		print(final_position, direction)
	else:
		var final_position = thumb - center
		thumb_icon.position = final_position
