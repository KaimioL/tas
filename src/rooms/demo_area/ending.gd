extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Jumper.player_pos = Vector2(328, 432)
	$Ground/Jumper.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
