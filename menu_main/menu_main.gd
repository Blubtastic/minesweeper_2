extends Node3D

@onready var env: WorldEnvironment = $Environment/Environment
@onready var animate_sun: AnimationPlayer = $Environment/AnimateSun

func _ready() -> void:
	Music.stop_music()
	Music.play_cozy()
	env.environment.fog_depth_begin = 0.0
	env.environment.fog_depth_end = 55.0
	fade_in_fog()

func fade_in_fog() -> void:
	animate_sun.play("animate_sun")
	var tween_start := create_tween()
	var tween_end := create_tween()
	tween_start.set_ease(Tween.EASE_IN_OUT)
	tween_end.set_ease(Tween.EASE_IN_OUT)
	tween_start.tween_property(env.environment, "fog_depth_begin", 6.0, 3.0)
	tween_end.tween_property(env.environment, "fog_depth_end", 55.0, 3.0)
