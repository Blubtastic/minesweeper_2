extends Button
const MAIN = preload("uid://c1p7v7melj8n4")

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
