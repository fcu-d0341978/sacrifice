extends Node2D

func _process(delta):
	scale = scale.linear_interpolate(Vector2(1, 1), delta * 8)

func _on_body_entered(body):
	if body.is_in_group("npc"):
		if body.has_method("jump"):
			body.jump(1.5)
			scale = Vector2(0.5, 1.5)
			
			Audio.play("res://Audio/spring.ogg")
