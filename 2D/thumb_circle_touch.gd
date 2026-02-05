extends Control

@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton
@onready var debug_touch_point: Label = $DebugTouchPoint
@onready var circle: Control = $Circle
@onready var thumb_icon: Polygon2D = $Circle/ThumbIcon

@export var max_radius = 150
const INITIAL: Vector2 = Vector2(0,0)
signal joystick_moved()

func _ready():
	disable_if_not_touch()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		debug_touch_point.text = str(event.position)
		move_thumb_icon(event)
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			print("released")
			thumb_icon.position = INITIAL
			joystick_moved.emit(INITIAL)

func move_thumb_icon(event: InputEventScreenDrag):
	var center: Vector2 = circle.global_position
	var thumb: Vector2 = event.position

	var direction = center - thumb
	var distance = direction.length()
	var final_position: Vector2 = thumb - center
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		final_position = -direction
	thumb_icon.position = final_position
	joystick_moved.emit(final_position)

func disable_if_not_touch():
	if DisplayServer.is_touchscreen_available():
		visible = true
		set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		visible = false
		set_process_mode(Node.PROCESS_MODE_DISABLED)
