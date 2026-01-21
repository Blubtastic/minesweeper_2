extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	if OS.has_feature("mobile"):
		visible = true
		print("Is mobile")
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		visible = true
		print("Android or iOS")
