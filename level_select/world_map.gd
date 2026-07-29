extends Node3D

@onready var player_model: Node3D = $PlayerModel
@onready var levels: Array[Area3D] = [$Levels/SelectLevel1_1, $Levels/SelectLevel1_2, $Levels/SelectLevel1_3, $Levels/SelectLevel1_4, $Levels/SelectLevel2_1, $Levels/SelectLevel2_2, $Levels/SelectLevel2_3, $Levels/SelectLevel3_1, $Levels/SelectLevel3_2, $Levels/SelectLevel3_3, $Levels/SelectLevel3_4]


func _ready() -> void:
	for level in levels:
		level.was_hovered.connect(move_to_position)


func move_to_position(new_position: Vector3, _level: int) -> void:
	player_model.position = Vector3(new_position.x, player_model.position.y, new_position.z)
