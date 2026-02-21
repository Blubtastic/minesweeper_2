extends Polygon2D

@export var radius = 50.0

func _ready():
	var points = []
	var segments = 32.0 
	for i in range(segments):
		var angle = (i / segments) * TAU
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	self.polygon = points
