extends Node3D

const GAME_OVER = preload("uid://qhpvf7y1n474")
@onready var hud: Control = $HUD

func _ready():
	Globals.game_ended.connect(_on_game_ended)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("restart"):
			Globals.reset_game()
			get_tree().reload_current_scene()

func _on_game_ended():
	hud.visible = false
	var game_over_instance = GAME_OVER.instantiate()
	add_child(game_over_instance)
