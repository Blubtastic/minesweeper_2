extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://2D/main_menu.tscn")
	Globals.reset_game()
