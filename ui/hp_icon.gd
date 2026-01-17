extends Sprite2D

@export var hp_count = 0

func _physics_process(_delta: float):
	if Globals.player_hp < hp_count:
		visible = false
