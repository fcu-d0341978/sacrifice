extends Node2D

onready var shrink = $Path2D/PathFollow2D/AnimatedSprite2/AnimationPlayer
onready var move = $Path2D/PathFollow2D/AnimatedSprite2/AnimationPlayer2
onready var pathFollow = $Path2D/PathFollow2D
onready var tween = $Path2D/PathFollow2D/Tween
var currentSelection = 0

func _ready():
#	shrink.play("shrink")
#	move.play("move")
	pass

func _process(delta):
	if Input.is_action_just_pressed("right"):
		tween.interpolate_property(get_node("Path2D/PathFollow2D"), "unit_offset", 0.0, 0.25, 0.25, Tween.TRANS_BACK, Tween.EASE_OUT, 0)
		tween.start()
#		if currentSelection >= 3:
#			currentSelection = 0
#		else:
#			currentSelection += 1
#		tween.interpolate_property(pathFollow, "unit_offset", 0.0, 1.0, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT, 1)
#			pathFollow.unit_offset += 0.25
	if Input.is_action_just_pressed("left"):
		if currentSelection <= 0:
			currentSelection = 3
		else:
			currentSelection -=1
	print(pathFollow.unit_offset)
	
	
