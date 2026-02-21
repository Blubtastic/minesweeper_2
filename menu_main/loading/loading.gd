extends Node3D
@onready var poof: GPUParticles3D = $Particles/Poof
@onready var sparks: GPUParticles3D = $Particles/Sparks
@onready var tire_debris_snow: Node3D = $Particles/TireDebrisSnow
@export var NEXT_SCENE: Resource

func _ready():
	poof.restart()
	sparks.restart()
	await get_tree().create_timer(0.5).timeout
	if NEXT_SCENE:
		get_tree().change_scene_to_packed(NEXT_SCENE)
	else:
		print("Can't change scene to NEXT_SCENE, value is ", NEXT_SCENE, ".")
