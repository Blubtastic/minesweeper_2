extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var duration: float = 1

func _ready() -> void:
	animation_player.speed_scale = 1/duration
	animation_player.play("fade_and_despawn")
