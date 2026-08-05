extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_clear: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconClear
@onready var icon_ace: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconAce
@onready var icon_full_clear: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconFullClear



func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_next_level_pressed() -> void:
	Globals.current_level += 1
	get_tree().change_scene_to_file('res://levels/level_' + str(int(Globals.current_level)) + '.tscn')


func handle_game_over() -> void:
	await get_tree().create_timer(0.25).timeout
	animation_player.play("show_rewards")
	icon_clear.visible = true
	icon_ace.visible = false
	icon_full_clear.visible = true
