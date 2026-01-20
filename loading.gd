extends Node3D
@onready var poof: GPUParticles3D = $Particles/Poof
@onready var sparks: GPUParticles3D = $Particles/Sparks
@onready var tire_debris_snow: Node3D = $Particles/TireDebrisSnow

func _ready():
	poof.restart()
	sparks.restart()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
