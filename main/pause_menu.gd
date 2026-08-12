extends Control


var is_menu_open: bool = false
@onready var resume: Button = $VBoxContainer/VBoxContainer/Resume
@onready var current_level_label: Label = $CurrentLevelLabel
@onready var icon_clear: PanelContainer = $VBoxContainer/IconMargin/Icons/IconClear
@onready var icon_ace: PanelContainer = $VBoxContainer/IconMargin/Icons/IconAce
@onready var icon_full_clear: PanelContainer = $VBoxContainer/IconMargin/Icons/IconFullClear


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	toggle_menu(is_menu_open)


func toggle_menu(is_open: bool) -> void:
	is_menu_open = is_open
	visible = is_open
	get_tree().paused = is_open
	if is_open:
		resume.grab_focus()
		current_level_label.text = "Level " + str(Globals.current_group) + " - " + str(Globals.current_level)
		var rewards_for_this_level: Dictionary = Globals.rewards_state[Globals.current_group][Globals.current_level]
		icon_clear.visible = rewards_for_this_level[1]
		icon_ace.visible = rewards_for_this_level[2]
		icon_full_clear.visible = rewards_for_this_level[3]


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("pause"):
			toggle_menu(true)


func _on_main_menu_pressed() -> void:
	toggle_menu(false)
	get_tree().change_scene_to_file("res://menu_main/menu_main.tscn")


func _on_restart_pressed() -> void:
	toggle_menu(false)
	Globals.reset_game()
	get_tree().reload_current_scene()


func _on_resume_pressed() -> void:
	toggle_menu(false)


func _on_world_map_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select/world_map.tscn")
