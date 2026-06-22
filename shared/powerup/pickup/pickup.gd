extends Node3D

class_name Pickup


@export var rotation_speed: float = 2

const IMPACT_GRENADE = preload("uid://5s7j7ty55jtj")
@onready var bomb: Node3D = $bomb
var powerups: Dictionary[String, PackedScene] = {
	'impact_grenade': IMPACT_GRENADE
}
var powerup: PackedScene = powerups['impact_grenade']


## TODO: when adding a new powerup, ask AI how to add an @export for choosing from a dict.
func _ready() -> void:
	bomb.visible = true

func _physics_process(delta: float) -> void:
	# Rotate around the Y axis
	rotate_y(rotation_speed * delta)


func pick_up() -> void:
	queue_free()
