extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")

@export var version_number := '0.0.0'
@onready var version_num: Label = $AnchorBottomRight/VersionNum
@onready var play_1: Button = $PlayButtons/Play1

func _ready() -> void:
	version_num.text = 'v' + version_number
	play_1.grab_focus()

func _on_endless_mode_pressed() -> void:
	Globals.game_mode = 1 # Stress mode
	Globals.is_2p = false
	get_tree().change_scene_to_packed(WORLD_MAP)

func _on_endless_mode_2_pressed() -> void:
	Globals.game_mode = 1 # Stress mode
	Globals.is_2p = true
	get_tree().change_scene_to_packed(WORLD_MAP)
