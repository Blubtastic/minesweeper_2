extends Control

@export var version_number := '0.0.0'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VersionNumber.text = 'v' + version_number
