extends Control

@onready var hp_3: Sprite2D = $HPBar/HP3
@onready var hp_2: Sprite2D = $HPBar/HP2
@onready var hp_1: Sprite2D = $HPBar/HP1


func _ready() -> void:
	Globals.shared_hp_changed.connect(_on_shared_hp_changed)


func _on_shared_hp_changed(new_hp):
	hp_3.visible = false if new_hp < 3 else true
	hp_2.visible = false if new_hp < 2 else true
	hp_1.visible = false if new_hp < 1 else true
