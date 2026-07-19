extends Node3D

@onready var player_model: Node3D = $PlayerModel
@onready var levels: Array[Area3D] = [$Levels/LevelSelectLevel1, $Levels/LevelSelectLevel2, $Levels/LevelSelectLevel3, $Levels/LevelSelectLevel4]


func _ready() -> void:
	for level in levels:
		level.was_hovered.connect(move_to_position)


func move_to_position(new_position: Vector3, _level: int) -> void:
	player_model.position = Vector3(new_position.x, player_model.position.y, new_position.z)
