extends Node2D

export (PackedScene) var debris

func destroy():
	
	var _debris = debris.instance()
	
	get_tree().get_root().add_child(_debris)
	
	_debris.position = position - Vector2(0, 5)
	_debris.emitting = true
	
	Audio.play("res://Audio/break.ogg")
	
	queue_free()
