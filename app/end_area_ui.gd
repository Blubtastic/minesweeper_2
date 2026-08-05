extends Control

const WORLD_MAP = preload("uid://dec4vccolfnnv")
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD_MAP)


func _on_next_level_pressed() -> void:
	Globals.current_level += 1
	get_tree().change_scene_to_file('res://levels/level_' + str(int(Globals.current_level)) + '.tscn')


func handle_game_over() -> void:
	await get_tree().create_timer(0.5).timeout
	animation_player.play("show_rewards")
