extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Console.add_command("room", console_load_room, 1)
	
func console_load_room(room_path):
	get_parent().load_room(room_path)
