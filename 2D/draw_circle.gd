extends Polygon2D

@export var radius = 50.0  # Change this to your desired radius

func _ready():
	var points = []
	var segments = 32.0  # Number of segments for the circle
	for i in range(segments):
		var angle = (i / segments) * TAU
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	# Set the points to the Polygon2D
	self.polygon = points
