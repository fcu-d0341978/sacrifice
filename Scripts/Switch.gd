extends Node2D

export var switchOn = false
var switchOnTexture = load("res://Sprites/Blocks/switchB.png")
var switchOffTexture = load("res://Sprites/Blocks/switchR.png")
onready var sprite = $Sprite

func _ready():
	if switchOn:
		sprite.texture = switchOnTexture
		SignalManager.emit_signal("changeState", true)
	else:
		sprite.texture = switchOffTexture
		SignalManager.emit_signal("changeState", false)

func _physics_process(delta):
	sprite.scale = sprite.scale.linear_interpolate(Vector2(1, 1), delta * 8)

func change():
	switchOn = !switchOn
	sprite.scale = Vector2(1.2, 0.8)
	if switchOn:
		sprite.texture = switchOnTexture
		SignalManager.emit_signal("changeState", true)
	else:
		sprite.texture = switchOffTexture
		SignalManager.emit_signal("changeState", false)
	
