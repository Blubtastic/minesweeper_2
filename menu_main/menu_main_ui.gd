extends Control

const MAIN = preload("uid://cqmyxt5a3dxys")

@export var version_number := '0.0.0'
@onready var version_num: Label = $AnchorBottomRight/VersionNum

func _ready() -> void:
	version_num.text = 'v' + version_number

func _on_play_pressed() -> void:
	Globals.game_mode = 0 # Chill mode
	get_tree().change_scene_to_packed(MAIN)

func _on_play_2_pressed() -> void:
	Globals.game_mode = 0 # Chill mode
	Globals.is_2p = true
	get_tree().change_scene_to_packed(MAIN)

func _on_endless_mode_pressed() -> void:
	Globals.game_mode = 1 # Stress mode
	get_tree().change_scene_to_packed(MAIN)

func _on_endless_mode_2_pressed() -> void:
	Globals.game_mode = 1 # Stress mode
	Globals.is_2p = true
	get_tree().change_scene_to_packed(MAIN)
