extends Control

@export var version_number := '0.0.0'
@onready var version_num: Label = $Version/VersionNum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version_num.text = 'v' + version_number
