extends Control

@export var max_blur: float = 3
@export var blur_speed: float = 12
@onready var elements: Control = $Elements
@onready var blur: TextureRect = $Blur

var amount: float = 0.0
var blur_has_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	elements.visible = false
	start_blur_after_delay()
	await get_tree().create_timer(1.2).timeout
	elements.visible = true

func _physics_process(delta: float) -> void:
	if blur_has_started:
		amount += delta*blur_speed
	if amount < max_blur:
		blur.material.set_shader_parameter("amount", amount)

func start_blur_after_delay(delay: float = 1):
	await get_tree().create_timer(delay).timeout
	blur_has_started = true
