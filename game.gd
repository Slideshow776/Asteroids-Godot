## palette: https://lospec.com/palette-list/akc12

extends Node2D

var score := 0

@onready var player = %Player
@onready var game_over_label = %GameOverLabel
@onready var score_label = %ScoreLabel


func _ready():
	_spawn_asteroids()


func _process(delta):	
	# detect player death
	if player == null:
		game_over_label.visible = true
	
	# wrap entities around screen
	for child in get_children():
		if child is CharacterBody2D or child is Area2D:
			_wrap(child)
	

func _input(event):
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()


func _spawn_asteroids():
	var viewport_size = get_viewport_rect().size
	var edge_buffer = 50.0  # Distance from the edge where asteroids will be placed

	for i in range(randi_range(5, 8)):
		var asteroid: Asteroid = preload("res://asteroid.tscn").instantiate()
		asteroid.set_size(asteroid.Size.LARGE)
		asteroid.connect("asteroid_destroyed", _on_asteroid_destroyed)
		
		# Determine a random edge and position near that edge
		var edge = randi_range(0, 3)  # Randomly choose an edge: 0 = top, 1 = right, 2 = bottom, 3 = left
		var spawn_position = Vector2()

		match edge:
			0:  # Top edge
				spawn_position.x = randf_range(edge_buffer, viewport_size.x - edge_buffer)
				spawn_position.y = edge_buffer
			1:  # Right edge
				spawn_position.x = viewport_size.x - edge_buffer
				spawn_position.y = randf_range(edge_buffer, viewport_size.y - edge_buffer)
			2:  # Bottom edge
				spawn_position.x = randf_range(edge_buffer, viewport_size.x - edge_buffer)
				spawn_position.y = viewport_size.y - edge_buffer
			3:  # Left edge
				spawn_position.x = edge_buffer
				spawn_position.y = randf_range(edge_buffer, viewport_size.y - edge_buffer)
		
		asteroid.position = spawn_position
		add_child(asteroid)


func _on_asteroid_destroyed(score: int):
	print("mark 0")
	_set_score(score)


func _wrap(characterBody2D: CollisionObject2D):
	if characterBody2D.position.x < 0.0:
		characterBody2D.position.x = get_viewport_rect().size.x
	elif characterBody2D.position.x > get_viewport_rect().size.x:
		characterBody2D.position.x = 0.0
		
	if characterBody2D.position.y < 0.0:
		characterBody2D.position.y = get_viewport_rect().size.y
	elif characterBody2D.position.y > get_viewport_rect().size.y:
		characterBody2D.position.y = 0.0


func _set_score(amount: int):
	score += amount
	score_label.text = "score: " + str(score)
