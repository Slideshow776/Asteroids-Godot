extends Area2D


const MOVEMENT_SPEED := 10
const ROTATION_SPEED := 3
const MAX_SPEED := 300
const NUM_SHOTS := 4

var velocity := Vector2.ZERO

@onready var shoot_timer = %ShootTimer


func _ready():
	area_entered.connect(_on_area_entered)
	rotation = randf_range(0, 2 * PI)


func _input(event):
	if Input.is_action_pressed("shoot") and shoot_timer.time_left == 0.0:
		shoot_timer.start()
		
		var instantiated_shot = preload("res://shot.tscn").instantiate()
		instantiated_shot.start(global_position, rotation)
		get_parent().add_child(instantiated_shot)
		
		var audio_stream_player = %AudioStreamPlayer
		audio_stream_player.pitch_scale = randf_range(0.92, 1.07)
		audio_stream_player.play()
		

func _physics_process(delta):	
	_handle_rotation(delta)
	
	if Input.is_action_pressed("forward"):
		velocity += Vector2(0, -MOVEMENT_SPEED)	.rotated(rotation)
	
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	
	position += velocity * delta


func _on_area_entered(area_that_entered: Area2D):
	var audio_stream_player = %AudioStreamPlayer2
	audio_stream_player.play()
	audio_stream_player.connect("finished", queue_free)
	queue_free()


func _handle_rotation(delta: float):	
	if Input.is_action_pressed("rotate_left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += ROTATION_SPEED * delta
