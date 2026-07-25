extends Button

@onready var normal_label: Label = $Label
@onready var active_label: Label = $SubViewportContainer/SubViewport/ColorRect/Label
@export var new_text: String = ''
@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer

var state: int = 1

func _ready() -> void:
	if new_text:
		active_label.text = new_text
		normal_label.text = new_text


func set_normal() -> void:
	if state != 1:
		state = 1
		normal_label.visible = true
		sub_viewport_container.visible = false

func set_active() -> void:
	if state != 2:
		state = 2
		normal_label.visible = false
		sub_viewport_container.visible = true


## Update visual state based on focus
func _on_focus_entered() -> void:
	set_active()

func _on_focus_exited() -> void:
	set_normal()


## Programatically set focus
func _on_mouse_entered() -> void:
	grab_focus()

func _on_mouse_exited() -> void:
	release_focus()
