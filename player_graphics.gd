extends Node2D

var color = Color("#ffeb99")
var thickness := 3
var points : Array[Vector2] = [
	Vector2(0, -20),
	Vector2(-10, 10),
	Vector2(10, 10),
]


func _draw():
	draw_line(points[0], points[1], color, thickness)
	draw_line(points[1], points[2], color, thickness)
	draw_line(points[2], points[0], color, thickness)
	
