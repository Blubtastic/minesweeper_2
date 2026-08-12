extends Control


@onready var resume: Button = $VBoxContainer/VBoxContainer/Resume
@onready var current_level_label: Label = $CurrentLevelLabel
@onready var icon_clear: PanelContainer = $VBoxContainer/IconMargin/Icons/IconClear
@onready var icon_ace: PanelContainer = $VBoxContainer/IconMargin/Icons/IconAce
@onready var icon_full_clear: PanelContainer = $VBoxContainer/IconMargin/Icons/IconFullClear


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	toggle_menu(false)


func toggle_menu(is_open: bool) -> void:
	visible = is_open
	if is_inside_tree():
		get_tree().paused = is_open
	if is_open:
		resume.grab_focus()
		current_level_label.text = "Level " + str(Globals.current_group) + " - " + str(Globals.current_level)
		icon_clear.visible = Storage.get_current_level_reward(1)
		icon_ace.visible = Storage.get_current_level_reward(2)
		icon_full_clear.visible = Storage.get_current_level_reward(3)


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
	toggle_menu(false)
	get_tree().change_scene_to_file("res://level_select/world_map.tscn")
