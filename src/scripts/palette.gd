extends Node

var sprite_palettes: Array[CompressedTexture2D]

# 0 White flash
# 1 Enemy type palette #1
# 2 Enemy type palette #2
# 3 Enemy type palette #3
# 4 Player
# 5 Lots of stuff
# 6 Beams
# 7 Enemy type palette #4

var background_palettes: Array[CompressedTexture2D]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_palettes.resize(8)
	background_palettes.resize(8)
	sprite_palettes[0] = load("res://assets/sprites/player/player_palette.png")
	sprite_palettes[1] = load("res://assets/sprites/enemies/enemy_palette_1.png")
func get_sprite_palette(palette_index):
	return sprite_palettes[palette_index]
