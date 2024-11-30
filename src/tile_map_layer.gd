extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.ending > 0:
		material.set_shader_parameter("red_displacement", 0.2)
	if Globals.ending > 1:
		material.set_shader_parameter("red_displacement", 0.5)
	if Globals.ending > 2:
		material.set_shader_parameter("blue_displacement", 0.2)
	if Globals.ending > 3:
		material.set_shader_parameter("green_displacement", 0.2)
		material.set_shader_parameter("intensity", 0.5)
	if Globals.ending > 4:
		material.set_shader_parameter("blue_displacement", 0.5)
	if Globals.ending > 5:
		material.set_shader_parameter("green_displacement", 0.5)
		material.set_shader_parameter("distortion_effect", 0.5)
	if Globals.ending > 6:
		material.set_shader_parameter("red_displacement", 0.7)
	if Globals.ending > 7:
		material.set_shader_parameter("green_displacement", 0.7)
		material.set_shader_parameter("ghost", 0.5)
	if Globals.ending > 8:
		material.set_shader_parameter("blue_displacement", 1)
		material.set_shader_parameter("scan_effect", 0.5)
	if Globals.ending > 9:
		material.set_shader_parameter("negative_effect", 0.5)
		material.set_shader_parameter("green_displacement", 1)
		material.set_shader_parameter("intensity", 1)
	if Globals.ending > 10:
		material.set_shader_parameter("red_displacement", 1)
		
	
		
		
		
