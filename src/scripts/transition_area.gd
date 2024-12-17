extends Area2D

func _on_body_entered(body: Node2D) -> void:
	MetSys.visit_cell(Vector3i(0,0,0))
