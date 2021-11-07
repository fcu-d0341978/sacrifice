extends KinematicBody2D

# Public

onready var sprite = $Sprite
onready var camera = $Camera
onready var dust   = $Dust
onready var timer = $CoyoteTimer
onready var bufferTimer = $BufferTimer
onready var raycast1 = $RayCast2D
onready var raycast2 = $RayCast2D2

export var maxMovementSpeed = 20
export var acceleration = 0.2
export var airAcceleration = 0.12
export var gravityPower = 20
export var jumpPower = 35
export var groundFric = 0.4
export var airFric = 0.05

# Private

var velocity = Vector2(0, 0)
var movementVelocity = Vector2(0, 0)
var gravity = 0

var previouslyFloored = false
var previouslyDestroyed = false
var onLadder = false
var coyoteJump = false
var bufferJump = false

var cameraTarget = 0.5

var initialPosition

# Methods

func _ready():
	
	initialPosition = position

func _physics_process(delta):
	applyControls()
	applyGravity()
	applyAnimation()
	applyCamera(delta)
	
	# Out of bounds
	
	if position.y > 200 or Input.is_action_just_pressed("reset"):
		position = initialPosition
	
	# Apply movement
	
	velocity = velocity.linear_interpolate(movementVelocity * 10, delta * 15)
# warning-ignore:return_value_discarded
	move_and_slide(velocity + Vector2(0, gravity), Vector2(0, -1))
	
	# Effects
	
	sprite.scale = sprite.scale.linear_interpolate(Vector2(1, 1), delta * 8)
	
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		if is_on_floor():
			applyGroundFric()
		
		if !is_on_floor():
			applyAirFric()
	
	if is_on_floor() and !previouslyFloored:
		sprite.scale = Vector2(1.25, 0.9)
	
	if !is_on_floor() and previouslyFloored:
		timer.start(0.1)
		coyoteJump = true
	
	if is_on_wall():
		movementVelocity.x = 0
	
	previouslyFloored = is_on_floor()
	
	if !is_on_floor() and (abs(velocity.x) > 20 or abs(velocity.y) > 20):
		dust.emitting = true
	else:
		dust.emitting = false
	
# Player controls

func applyControls():

#	movementVelocity = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		if is_on_floor():
			movementVelocity.x = lerp(movementVelocity.x, -maxMovementSpeed, acceleration)
		else:
			movementVelocity.x = lerp(movementVelocity.x, -maxMovementSpeed, airAcceleration)
		sprite.flip_h = false
		raycast1.position.x = -5
		
	elif Input.is_action_pressed("right"):
		if is_on_floor():
			movementVelocity.x = lerp(movementVelocity.x, maxMovementSpeed, acceleration)
		else:
			movementVelocity.x = lerp(movementVelocity.x, maxMovementSpeed, airAcceleration)
		sprite.flip_h = true
		raycast1.position.x = 5
	
	if onLadder:
		if Input.is_action_pressed("up"):
			
			movementVelocity.y = -maxMovementSpeed / 2
			
		elif Input.is_action_pressed("down"):
			
			movementVelocity.y = maxMovementSpeed / 2
	
	if Input.is_action_just_pressed("jump") and !is_on_floor():
		bufferTimer.start(0.1)
		bufferJump = true
	if is_on_floor() and bufferJump: jump(1)
	if Input.is_action_just_pressed("jump") and (is_on_floor() or onLadder): jump(1)
	if Input.is_action_just_pressed("jump") and !is_on_floor() and coyoteJump: jump(1)
	if Input.is_action_just_released("jump") and gravity < -150:
		gravity = -jumpPower * 5
		
func applyGroundFric():
	movementVelocity.x = lerp(movementVelocity.x, 0, groundFric)

func applyAirFric():
	movementVelocity.x = lerp(movementVelocity.x, 0, airFric)
# Apply gravity and jumping

func applyGravity():

	if !onLadder:
		gravity += gravityPower
	else:
		gravity = lerp(gravity, 0, 0.1)
	
	if gravity > 0 and is_on_floor():
		gravity = 10
		previouslyDestroyed = false
		
	if is_on_ceiling(): gravity = 0
	
func jump(multiplier):
	gravity = -jumpPower * multiplier * 10
	sprite.scale = Vector2(0.5, 1.5)
	
	Audio.play("res://Audio/jump.ogg")
	
# Set animations

func applyAnimation():
	
	if onLadder:
		if abs(velocity.x) > 20 or abs(velocity.y) > 20:
			sprite.play("climb")
		else:
			sprite.play("climb")
			sprite.stop()
	else:
		if is_on_floor():
			if abs(velocity.x) > 50:
				sprite.play("walk")
			elif !raycast1.is_colliding() and !raycast2.is_colliding():
				sprite.play("edge")
			else:
				sprite.play("idle")
		else:
			sprite.play("jump")

# Camera

func applyCamera(delta):
	
	if onLadder: cameraTarget = 0.3
	else: cameraTarget = 0.5
	
	camera.zoom = camera.zoom.linear_interpolate(Vector2(cameraTarget, cameraTarget), delta * 2)

# Ladder

func ladderEnable():  onLadder = true	
func ladderDisable(): onLadder = false

# Head collision

func _on_head_entered(body):
	if !previouslyDestroyed and gravity < 0 and body.has_method("destroy"):
		body.destroy()
		gravity = 0
		previouslyDestroyed = true
	
	if gravity < 0 and body.has_method("change"):
		body.change()


func _on_bottom_entered(body):
	if body.has_method("hit"): body.hit(self)


func _on_Timer_timeout():
	coyoteJump = false


func _on_BufferTimer_timeout():
	bufferJump = false
