extends Node3D

const GAME_OVER = preload("uid://ck8cc332mqpua")

@onready var hud: Control = $HUD

func _ready():
	Globals.reset_game()
	Globals.game_ended.connect(_on_game_ended)
	Music.restart_music()
	Music.stop_cozy()
	Music.mute_drums(true)
	Music.mute_tambourine(true)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("restart"):
			get_tree().reload_current_scene()

func _on_game_ended():
	hud.visible = false
	var game_over_instance = GAME_OVER.instantiate()
	add_child(game_over_instance)
	Music.kill_music()
	var tween = create_tween()
	tween.tween_method(Globals.set_world_speed, Globals.world_speed, 0, 2)
