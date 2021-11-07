extends StaticBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
var onSprite = load("res://Sprites/Blocks/switchBlockRFull.png")
var offSprite = load("res://Sprites/Blocks/switchBlockREmpty.png")

func _ready():
	SignalManager.connect("changeState", self, "change")

func change(isOn):
	if !isOn:
		sprite.texture = onSprite
		collision.set_deferred("disabled", false)
	else:
		sprite.texture = offSprite
		collision.set_deferred("disabled", true)
