extends Node3D

@onready var damage_player: Area3D = $DamagePlayer

func _ready():
	await get_tree().create_timer(0.2).timeout
	damage_player.monitorable = false
