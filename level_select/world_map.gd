extends Node3D

@onready var player_model: Node3D = $PlayerModel
@onready var levels: Array[LevelSelectLevel] = [$Levels/SelectLevel1_1, $Levels/SelectLevel1_2, $Levels/SelectLevel1_3, $Levels/SelectLevel1_4, $Levels/SelectLevel2_1, $Levels/SelectLevel2_2, $Levels/SelectLevel2_3, $Levels/SelectLevel3_1, $Levels/SelectLevel3_2, $Levels/SelectLevel3_3, $Levels/SelectLevel3_4]
@onready var initially_selected_level: LevelSelectLevel = $Levels/SelectLevel1_1

var selected_level: LevelSelectLevel
#var level_selects: Array = []

func _ready() -> void:
	selected_level = initially_selected_level
	for level in levels:
		level.was_hovered.connect(move_to_position)
	#level_selects = get_tree().get_nodes_in_group("level_select_buttons")

func move_to_position(new_position: Vector3, _level: int) -> void:
	player_model.position = Vector3(new_position.x, player_model.position.y, new_position.z)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("ui_left") and selected_level.left:
			selected_level = selected_level.left
		if event.is_action_pressed("ui_right") and selected_level.right:
			selected_level = selected_level.right
		if event.is_action_pressed("ui_up") and selected_level.up:
			selected_level = selected_level.up
		if event.is_action_pressed("ui_down") and selected_level.down:
			selected_level = selected_level.down
	handle_focus_change()


func handle_focus_change() -> void:
	for level in levels:
		level.release_focus()
	selected_level.grab_focus()
