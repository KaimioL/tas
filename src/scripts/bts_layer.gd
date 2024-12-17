extends TileMapLayer

@export var layer_1: TileMapLayer

func remove_graphics_tile(position):
	layer_1.erase_cell(local_to_map(position))
	
