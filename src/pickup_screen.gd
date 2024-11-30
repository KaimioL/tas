extends ColorRect

signal closed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and $Timer.is_stopped():
		hide()
		closed.emit()
