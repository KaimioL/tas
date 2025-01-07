extends Area2D
class_name CameraArea

func _on_body_entered(body: Node2D) -> void:
	Signals.camera_boundary_changed.emit(Vector4(position.x, position.y, position.x + $CollisionShape2D.shape.size.x, position.y + $CollisionShape2D.shape.size.y))
