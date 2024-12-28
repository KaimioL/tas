extends Node2D

var lsprite: Sprite2D
var rsprite: Sprite2D
var usprite: Sprite2D
var dsprite: Sprite2D

@export var palette_index: int = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	material.set_shader_parameter("palette", Palette.get_palette(palette_index))

func initialize_offscreen_sprites():
	lsprite = Sprite2D.new()
	lsprite.name == "LSprite"
	add_child(lsprite)
	rsprite = Sprite2D.new()
	rsprite.name == "LSprite"
	add_child(rsprite)
	usprite = Sprite2D.new()
	usprite.name == "LSprite"
	add_child(usprite)
	dsprite = Sprite2D.new()
	dsprite.name == "LSprite"
	add_child(dsprite)

func update_offscreen_sprites():
	copy_properties(lsprite)
	copy_properties(rsprite)
	copy_properties(dsprite)
	copy_properties(usprite)
	
	lsprite.global_position = global_position + Vector2(-256*2, 0)
	rsprite.global_position = global_position + Vector2(256*2, 0)
	usprite.global_position = global_position + Vector2(0, -256)
	dsprite.global_position = global_position + Vector2(0, 256)

func copy_properties(node: Sprite2D):
	pass
	#node.texture = texture
	#node.centered = centered
	#node.offset = offset
	#node.flip_h = flip_h
	#node.hframes = hframes
	#node.vframes = vframes
	#node.frame = frame
	#node.frame_coords = frame_coords
	#node.rotation = rotation
	#node.scale = scale
	#node.skew = skew
	#node.visible = visible
	#node.modulate = modulate
	#node.self_modulate = self_modulate
	#node.show_behind_parent = show_behind_parent
	#node.top_level = top_level
	#node.clip_children = clip_children
	#node.light_mask = light_mask
	#node.visibility_layer = visibility_layer
	#node.z_index = z_index
	#node.z_as_relative = z_as_relative
	#node.y_sort_enabled = y_sort_enabled
	#node.use_parent_material = true
