extends Control


var is_menu_open: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	toggle_menu(is_menu_open)


func toggle_menu(is_open: bool) -> void:
	is_menu_open = is_open
	visible = is_open
	get_tree().paused = is_open


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("pause"):
			toggle_menu(true)


func _on_main_menu_pressed() -> void:
	toggle_menu(false)
	Globals.reset_game()
	get_tree().change_scene_to_file("res://menu_main/menu_main.tscn")


func _on_restart_pressed() -> void:
	toggle_menu(false)
	Globals.reset_game()
	get_tree().reload_current_scene()


func _on_cancel_pressed() -> void:
	toggle_menu(false)
