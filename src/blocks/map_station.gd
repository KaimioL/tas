extends Node2D

@export var map_index: int

func _on_area_2d_body_entered(body: Node2D) -> void:
	MetSys.discover_cell_group(map_index)
