extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.velocity.y < 0:
			print("aaa")
			body.velocity.y -= 150
