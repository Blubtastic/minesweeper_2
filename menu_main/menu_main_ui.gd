extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")

@export var version_number := '0.0.0'
@onready var version_num: Label = $AnchorBottomRight/VersionNum
@onready var single_player: Button = $MarginContainer/VBoxContainer2/SinglePlayer

func _ready() -> void:
	version_num.text = 'v' + version_number
	single_player.grab_focus()


func _on_single_player_pressed() -> void:
	Globals.is_2p = false
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_co_op_pressed() -> void:
	Globals.is_2p = true
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_reset_saved_data_pressed() -> void:
	Storage.reset_saved_data()
