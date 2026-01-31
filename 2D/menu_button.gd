extends Button

const MAIN_MENU = preload("uid://celxavas2i8qt")

func _on_pressed() -> void:
	Globals.reset_game()
	get_tree().change_scene_to_packed(MAIN_MENU)
