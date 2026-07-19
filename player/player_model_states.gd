extends Node3D

@export var state: int = 3
@onready var player_model_1: Node3D = $PlayerModel1
@onready var player_model_2: Node3D = $PlayerModel2
@onready var player_model_3: Node3D = $PlayerModel3

func _ready() -> void:
	change_state(state)

func change_state(new_state: int) -> void:
	if new_state == 3:
		player_model_1.visible = true
		player_model_2.visible = false
		player_model_3.visible = false
	if new_state == 2:
		player_model_1.visible = false
		player_model_2.visible = true
		player_model_3.visible = false
	if new_state == 1:
		player_model_1.visible = false
		player_model_2.visible = false
		player_model_3.visible = true
