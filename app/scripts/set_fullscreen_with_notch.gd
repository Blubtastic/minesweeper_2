extends MarginContainer

# SET ANY MARGINS YOU WANT TO INCLUDE IN PROJECT HERE, DISREGARDING THE NOTCH CALCULATION
@export var top_margin: int = 0
@export var left_margin: int = 0
@export var bottom_margin: int = 0
@export var right_margin: int = 0

@onready var window : Window = get_window()

func _ready():
	handle_notches()

func handle_notches():
	var os_name = OS.get_name()
	if os_name == "Android" || os_name ==  "iOS":
		# this indicates the area below the notch's dimensions
		var safe_area: Rect2i  = DisplayServer.get_display_safe_area()

		var window_size = window.size
		print("window_size: ", window_size)

		if window_size.y >= safe_area.size.y:
			top_margin += safe_area.position.y
			bottom_margin += window_size.y - (safe_area.position.y + safe_area.size.y)
		if window_size.x >= safe_area.size.x:
			left_margin += safe_area.position.x
			right_margin += window_size.x - (safe_area.position.x + safe_area.size.x)
		
		# OVERRIDE MARGIN CONTAINER
		add_theme_constant_override("margin_top", top_margin)
		add_theme_constant_override("margin_left", left_margin)
		add_theme_constant_override("margin_right", right_margin)
		add_theme_constant_override("margin_bottom", bottom_margin)
