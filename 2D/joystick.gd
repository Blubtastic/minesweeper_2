extends Control

@onready var touch_screen_button: TouchScreenButton = $TouchScreenButton
@onready var debug_touch_point: Label = $DebugTouchPoint
@onready var circle: Control = $Circle
@onready var icon_movable: Polygon2D = $Circle/ThumbIcon

@export var max_radius: int = 150
const INITIAL: Vector2 = Vector2(0,0)
signal joystick_moved()

func _ready():
	disable_if_not_touch()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		debug_touch_point.text = str(event.position)
		move_joystick(event)
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			move_joystick()

func move_joystick(event: InputEventScreenDrag = null):
	if event == null:
		icon_movable.position = INITIAL
		joystick_moved.emit(INITIAL)
		return
	
	var center: Vector2 = circle.global_position
	var thumb: Vector2 = event.position
	var direction = center - thumb
	var distance = direction.length()
	var clamped_position: Vector2 = thumb - center
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		clamped_position = -direction
	icon_movable.position = clamped_position
	joystick_moved.emit(clamped_position)

func disable_if_not_touch():
	if DisplayServer.is_touchscreen_available():
		visible = true
		set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		visible = false
		set_process_mode(Node.PROCESS_MODE_DISABLED)
