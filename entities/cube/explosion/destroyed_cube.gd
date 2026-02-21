extends Node3D

@onready var damage_player: Area3D = $DamagePlayer

func _ready():
	damage_player.monitorable = true
	await get_tree().create_timer(1.0).timeout
	damage_player.monitorable = false
