extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_clear: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconClear
@onready var icon_ace: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconAce
@onready var icon_full_clear: PanelContainer = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/IconMargin/Icons/IconFullClear
@onready var level_label: Label = $VBoxContainer/CenterChildren/CenterPanel/VBoxContainer/Label


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_next_level_pressed() -> void:
	Globals.current_level += 1
	#Globals.current_group
	var path := 'res://levels/level_' + str(int(Globals.current_group)) + '_' + str(int(Globals.current_level)) + '.tscn'
	get_tree().change_scene_to_file(path)


func handle_game_over() -> void:
	Globals.set_reward_vars() # TODO: MOVE TO GLOBALS IN LEVEL_COMPLETED FUNC
	await get_tree().create_timer(0.25).timeout
	animation_player.play("show_rewards")
	icon_clear.visible = true
	icon_ace.visible = Globals.level_aced
	icon_full_clear.visible = Globals.level_full_cleared
	level_label.text = "Level " + str(Globals.current_group) + " - " + str(Globals.current_level)
