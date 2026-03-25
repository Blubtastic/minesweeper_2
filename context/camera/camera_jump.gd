extends Node3D

const CAMERA_JUMP_CURVE = preload("uid://ckyoktsd8fghh")
var initial_y: float = 0

func _ready():
	initial_y = position.y
	Globals.start_exploded_cube_effects.connect(on_cube_exploded)

func on_cube_exploded():
	var tween = get_tree().create_tween()
	if Globals.player_hp < 2: # unclean - depends on player_hp. Instead, improve signal to fire with updated game_over info.
		tween.tween_method(camera_jump.bind(10), 0.0, 0.4, .2)
	else:
		tween.tween_method(camera_jump, 0.0, 1.0, 1.2)

func camera_jump(elapsed_time: float, intensity: float = 0.5):
	position.y = initial_y + (CAMERA_JUMP_CURVE.sample(elapsed_time)*intensity)
