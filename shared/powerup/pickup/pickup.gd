extends Area3D

class_name Pickup


@export var rotation_speed: float = 2

const IMPACT_GRENADE = preload("uid://5s7j7ty55jtj")
const BULLDOZER = preload("uid://ct351pbej5lhe")
var powerups: Dictionary[String, PackedScene] = {
	'impact_grenade': IMPACT_GRENADE,
	'bulldozer': BULLDOZER,
}
var powerup: PackedScene = null

@onready var bomb: Node3D = $bomb
@onready var mine_clearer: Node3D = $MineClearer


func _ready() -> void:
	randomize()
	var rng := RandomNumberGenerator.new()
	var random_number := rng.randf_range(0.0, 1.0)
	if random_number > 0.5:
		bomb.visible = true
		mine_clearer.visible = false
		powerup = powerups['impact_grenade']
	else:
		bomb.visible = false
		mine_clearer.visible = true
		powerup = powerups['bulldozer']


func _physics_process(delta: float) -> void:
	# Rotate around the Y axis
	rotate_y(rotation_speed * delta)


func pick_up() -> void:
	queue_free()
