extends Node

func _on_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		Audio.play("res://Audio/coin.ogg")
