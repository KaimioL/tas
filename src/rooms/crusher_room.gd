extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().pickup_screen_closed.connect(_on_pickup_screen_closed)

func _on_pickup_screen_closed():
	$Crusher/AnimationPlayer.play("crush")
