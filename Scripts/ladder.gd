extends Node

func _on_body_entered(body):
	if body.is_in_group("player"): body.ladderEnable()

func _on_body_exited(body):
	if body.is_in_group("player"): body.ladderDisable()
