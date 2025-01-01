extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Events.first_boss_killed:
		$Door.lock()
		$Door2.lock()
	else:
		$BigFlower.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
