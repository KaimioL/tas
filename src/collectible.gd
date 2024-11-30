extends Area2D

@export var item_name: String

func _ready() -> void:
	if Globals.is_pickup_collected(item_name):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	body.pickup_collected(item_name)
	Globals.pickup_collected(item_name)
	queue_free()
