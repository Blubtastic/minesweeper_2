extends Control

@onready var icon_movable: Polygon2D = $ThumbIcon

@export var max_radius: int = 100
var touch_radius: int = max_radius * 2
const INITIAL: Vector2 = Vector2(0,0)
signal joystick_moved()
var thumb_position = global_position
var lerped_thump_position = thumb_position

func _ready():
	disable_if_not_touch()

func _process(delta: float):
	lerped_thump_position = lerp(lerped_thump_position, thumb_position, delta*100)
	icon_movable.position = lerped_thump_position
	queue_redraw()

# Scoops up inputs not consumed by other things. Note that Control nodes covering an area will consume input before it reaches here.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		move_joystick(event)
	if event is InputEventScreenTouch:
		if not event.is_pressed():
			move_joystick()

func move_joystick(event: InputEventScreenDrag = null):
	if event == null:
		icon_movable.position = INITIAL
		joystick_moved.emit(INITIAL, 1)
		thumb_position = INITIAL
		return
	var center: Vector2 = global_position
	var thumb: Vector2 = event.position
	var direction = center - thumb
	var distance = direction.length()
	var clamped_position: Vector2 = thumb - center
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		clamped_position = -direction
	var speed = clamp(distance / max_radius, 0, 1)
	joystick_moved.emit(clamped_position, speed)
	thumb_position = clamped_position

func disable_if_not_touch():
	if DisplayServer.is_touchscreen_available():
		visible = true
		set_process_mode(Node.PROCESS_MODE_INHERIT)
	else:
		visible = false
		set_process_mode(Node.PROCESS_MODE_DISABLED)

func _draw():
	draw_line(INITIAL, lerped_thump_position, Color.BLACK, 2.0)
