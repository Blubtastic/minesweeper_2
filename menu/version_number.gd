extends Control

const MAIN = preload("uid://c1p7v7melj8n4")
@export var version_number := '0.0.0'
@onready var version_num: Label = $Version/VersionNum

func _ready() -> void:
	version_num.text = 'v' + version_number

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
