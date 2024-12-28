extends Node

var palettes: Array[CompressedTexture2D] = [null]
# 0 - 7 Tileset
# 8 White flash
# 9 Enemy type palette #1
# 10 Enemy type palette #2
# 11 Enemy type palette #3
# 12 Player
# 13 Lots of stuff
# 14 Beams
# 15 Enemy type palette #4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palettes[0] = load("res://assets/sprites/player/player_palette.png")

func get_palette(palette_index):
	return palettes[palette_index]
