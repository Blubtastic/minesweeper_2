extends Node

var score = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		score = 0