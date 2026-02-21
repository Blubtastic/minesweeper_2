extends Node3D
@onready var player_shadow: Sprite3D = $PlayerShadow
@onready var shadow_ray_cast: RayCast3D = $ShadowRayCast

func _physics_process(_delta: float):
	player_shadow.global_transform.origin = global_position
	player_shadow.global_rotation_degrees = Vector3.ZERO
	if shadow_ray_cast.is_colliding():
		player_shadow.global_transform.origin.y = shadow_ray_cast.get_collision_point().y + 0.2
		visible = true
	else:
		visible = false
