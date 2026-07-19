extends Button

@export var button_text: String
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if button_text:
		text = button_text


func _on_focus_entered() -> void:
	animate_focus()


func _on_mouse_entered() -> void:
	animate_focus()


func animate_focus() -> void:
	animation_player.play("pop")
