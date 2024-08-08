class_name Shot
extends Area2D

var movement_speed := 600
var velocity := Vector2.ZERO
const SPAWN_OFFSET := -30

@onready var timer: Timer = %Timer


func _ready():
	timer.connect("timeout", queue_free)
	area_entered.connect(_on_area_entered)


func _physics_process(delta):
	if velocity.length() > movement_speed:
		velocity = velocity.normalized() * movement_speed
			
	position += velocity * delta
	
	#var temp = velocity	
	#if move_and_slide():
		#_collision_response(temp)


func start(global_position: Vector2, angle: float):
	var offset = Vector2(0, SPAWN_OFFSET).rotated(angle)
	position = global_position + offset
	velocity = Vector2(1000, 0).rotated(angle - PI/2)
	

func end():
	position = Vector2(-1000, -1000)


func _on_area_entered(area_that_entered: Area2D):
	queue_free()

