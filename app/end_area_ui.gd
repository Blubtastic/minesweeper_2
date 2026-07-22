extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_next_level_pressed() -> void:
	Globals.current_level += 1
	get_tree().change_scene_to_file('res://levels/level_' + str(int(Globals.current_level)) + '.tscn')
