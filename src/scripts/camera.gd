extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.camera_boundary_changed.connect(_on_camera_boundary_changed)
	
func _on_camera_boundary_changed(camera_limit):
	limit_left = camera_limit.x
	limit_top = camera_limit.y
	limit_right = camera_limit.z
	limit_bottom = camera_limit.w
	
