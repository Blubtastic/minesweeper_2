extends Node3D

@onready var player_model: Node3D = $PlayerModel
var levels := [$Levels/LevelSelectLevel1, $Levels/LevelSelectLevel2, $Levels/LevelSelectLevel3, $Levels/LevelSelectLevel4]


func _ready() -> void:
	for level in levels:
		print(level)
		#level.was_clicked.connect(move_to_position)


func move_to_position(new_position: Vector3) -> void:
	player_model.position = new_position
