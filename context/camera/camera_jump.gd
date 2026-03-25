extends Node3D

const CAMERA_JUMP_CURVE = preload("uid://ckyoktsd8fghh")
var initial_y: float = 0
var intensity = 0.5

func _ready():
	initial_y = position.y
	Globals.start_exploded_cube_effects.connect(on_cube_exploded)

func on_cube_exploded():
	var tween = get_tree().create_tween()
	tween.tween_method(camera_jump, 0.0, 1.0, 1.2)

func camera_jump(elapsed_time: float):
	position.y = initial_y + (CAMERA_JUMP_CURVE.sample(elapsed_time)*intensity)
