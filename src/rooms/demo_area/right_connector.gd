extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("up"):
		$Light4.frame = 1
	else:
		$Light4.frame = 0
	if Input.is_action_pressed("down"):
		$Light2.frame = 1
	else:
		$Light2.frame = 0
	if Input.is_action_pressed("left"):
		$Light.frame = 1
	else:
		$Light.frame = 0
	if Input.is_action_pressed("right"):
		$Light3.frame = 1
	else:
		$Light3.frame = 0
