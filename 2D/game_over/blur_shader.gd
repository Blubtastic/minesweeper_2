extends CanvasLayer  # or TextureRect if you prefer

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	sprite_2d.material.set_shader_parameter("texture", get_viewport().get_texture())
