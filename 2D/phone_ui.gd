extends Control
@onready var phone_only: Control = $PhoneOnly

func _ready() -> void:
	if DisplayServer.is_touchscreen_available():
		phone_only.visible = true
	else:
		phone_only.visible = false
