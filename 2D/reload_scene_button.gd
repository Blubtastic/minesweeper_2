extends Button

func _on_pressed() -> void:
	Globals.reset_game()
	get_tree().reload_current_scene()
