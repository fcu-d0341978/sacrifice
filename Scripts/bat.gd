extends KinematicBody2D

# Public

onready var sprite = $Sprite

export var movementSpeed = 20
export var gravityPower = 10

# Private

var direction = 0
var gravity = 0
var dead = false

# Methods

func _physics_process(delta):
	
	if dead :
		
		gravity += gravityPower
		position.y += gravity * delta
		
		return
	
	if direction == 0:
		
		move_and_slide(Vector2(0,  movementSpeed), Vector2(0, -1))
		
	else:
		
		move_and_slide(Vector2(0, -movementSpeed), Vector2(0, -1))
		
	if is_on_ceiling() or is_on_floor():
		
		if direction == 0: direction = 1
		elif direction == 1: direction = 0

func hit(body):
	
	if dead : return
	
	add_collision_exception_with(body)
	body.jump(1)
	
	sprite.stop()
	sprite.flip_v = true
	
	dead = true
	gravity = -120
	
	Audio.play("res://Audio/hit.ogg")
