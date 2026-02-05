extends Control

@onready var icon_movable: Polygon2D = $ThumbIcon

@export var max_radius: int = 100
var touch_radius: int = max_radius * 2
const INITIAL: Vector2 = Vector2(0,0)
signal joystick_moved()

func _ready():
	disable_if_not_touch()

# Scoops up inputs not consumed by other things. Note that Control nodes covering an area will consume input before it reaches here.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		move_joystick(event)
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			move_joystick()
			# TODO: Maybe this code is a problem. If an event is NOT drag, reset joystick. 
			# Cleanest would be to reset joystick of ALL events are not Drag. 



func move_joystick(event: InputEventScreenDrag = null):
	if event == null:
		icon_movable.position = INITIAL
		joystick_moved.emit(INITIAL, 1)
		return
	
	var center: Vector2 = global_position
	var thumb: Vector2 = event.position
	var direction = center - thumb
	var distance = direction.length()
	var clamped_position: Vector2 = thumb - center
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		clamped_position = -direction
	icon_movable.position = clamped_position
	var speed = clamp(distance / max_radius, 0, 1)
	joystick_moved.emit(clamped_position, speed)

func disable_if_not_touch():
	if DisplayServer.is_touchscreen_available():
		visible = true
		set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		visible = false
		set_process_mode(Node.PROCESS_MODE_DISABLED)
