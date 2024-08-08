class_name Asteroid
extends Area2D

signal asteroid_destroyed(score)

enum Size {SMALL, MEDIUM, LARGE}

var movement_speed := 100
var velocity := Vector2.ZERO
var angle := randf_range(0, 2 * PI)
var rotation_factor := 1.0

var asteroid_points = []
var max_radius = 100.0

var size := Size.MEDIUM
var color := Color("#000000")
var thickness := 4

var is_dead = false


func _ready():	
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	rotation += rotation_factor * delta
	velocity = Vector2(0, movement_speed).rotated(angle)
	
	position += velocity * delta
	
	#if move_and_slide():
		#_collision_response()


func _draw():
	for i in range(asteroid_points.size()):
		var start_point = asteroid_points[i]
		var end_point = asteroid_points[(i + 1) % asteroid_points.size()]
		draw_line(start_point, end_point, color, thickness)


func _on_area_entered(area_that_entered: Area2D):
	if is_dead:
		return
	
	var audio_stream_player = %AudioStreamPlayer
	audio_stream_player.volume_db = 0
	audio_stream_player.play()
	
	if size == Size.LARGE:
		_spawn_asteroids(Size.MEDIUM, randi_range(2, 3))
		audio_stream_player.pitch_scale = randf_range(0.5, 0.6)
	elif size == Size.MEDIUM:
		_spawn_asteroids(Size.SMALL, randi_range(3, 5))
		audio_stream_player.pitch_scale = randf_range(0.8, 0.9)
	
	position = Vector2(-1000, -1000)
	audio_stream_player.connect("finished", queue_free)
	
	emit_signal("asteroid_destroyed", _getScore(size))


func set_size(size: Size):
	self.size = size
	asteroid_points = _generate_asteroid(_get_size(size))
	%CollisionShape2D.shape.radius = _get_size(size) * 0.725
	_set_color(size)
	_set_thickness(size)
	_set_movement(size)


func _getScore(size: Size):
	match size:
		Size.SMALL: return 50
		Size.MEDIUM: return 100
		Size.LARGE: return 200
	return 0

func _spawn_asteroids(size: Size, number_of_asteroids):
	for i in number_of_asteroids:
		var asteroid: Asteroid = preload("res://asteroid.tscn").instantiate()
		asteroid.set_size(size)
		asteroid.position = global_position
		get_parent().add_child(asteroid)
		
		asteroid.connect("asteroid_destroyed", get_parent()._on_asteroid_destroyed)


func _get_size(size: Size) -> float:	
	match size:
		Size.SMALL: return 25.0
		Size.MEDIUM: return 40.0
		Size.LARGE: return 60.0
	return 40.0
	
	
func _set_color(size: Size):
	match size:
		Size.SMALL: color = Color("#94c5ac")
		Size.MEDIUM: color = Color("#6aaf9d")
		Size.LARGE: color = Color("#355d68")


func _set_thickness(size: Size):
	match size:
		Size.SMALL: thickness = 3
		Size.MEDIUM: thickness = 4
		Size.LARGE: thickness = 5


func _set_movement(size: Size):
	angle = randf_range(0, 2 * PI)
	match size:
		Size.SMALL: 
			movement_speed = randf_range(80.0, 95.0)
			rotation_factor = randf_range(0.8, 1.2)
		Size.MEDIUM: 
			movement_speed = randf_range(50.0, 65.0)
			rotation_factor = randf_range(0.3, 0.5)
		Size.LARGE: 
			movement_speed = randf_range(25.0, 30.0)
			rotation_factor = randf_range(0.05, 0.1)


func _generate_asteroid(max_radius):
	var num_faces = randi() % 11 + 5
	var points = []
	
	# Control the range of radii to ensure less spiky asteroids
	var min_radius = max_radius * 0.6
	
	# Generate points in counterclockwise order
	for i in range(num_faces):
		var angle = i * (PI * 2 / num_faces)
		# Generate a radius between min_radius and max_radius
		var radius = randf_range(min_radius, max_radius)
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
	
	return points
