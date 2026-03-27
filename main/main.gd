extends Node3D

const GAME_OVER = preload("uid://ck8cc332mqpua")
const GAME_PLAYER = preload("uid://b0boueut21rwe")
@onready var game_player: Node3D = $GamePlayer

@onready var hud: Control = $HUD

func _ready():
	Globals.reset_game()
	Globals.game_ended.connect(_on_game_ended)
	Music.restart_music()
	Music.stop_cozy()
	Music.mute_drums(true)
	Music.mute_tambourine(true)
	if Globals.is_2p:
		var player_2 = GAME_PLAYER.instantiate()
		player_2.position = Vector3(game_player.position.x+3, game_player.position.y, game_player.position.z)
		add_child(player_2)

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

# TODO 2: control world_speed increase/decrease from here
	# One mode for gradually increase it (Stress mode)
	# One mode for setting it to player_speed if player.position.z < -3 or something (Chill mode)
