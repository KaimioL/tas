extends Node

var bad_map = true
var pinch_collected = false
var float_collected = false
var map_collected = false
var glitch_collected = false
var fake_map_collected = false
var health_collected = false
var ending = 15

signal map_type_changed
signal got_pickup(pickup_name)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_D:
				if map_collected:
					# D toggles position tracking (delta vector).
					bad_map = not bad_map
					map_type_changed.emit()

func pickup_collected(pickup_name):
	if pickup_name == "pinch":
		pinch_collected = true
	if pickup_name == "float":
		float_collected = true
	if pickup_name == "map":
		map_collected = true
	if pickup_name == "glitch":
		glitch_collected = true
	if pickup_name == "fake_map":
		fake_map_collected = true
	if pickup_name == "health":
		health_collected = true
	got_pickup.emit(pickup_name)
	
func is_pickup_collected(pickup_name):
	if pickup_name == "pinch":
		if pinch_collected == true:
			return true
	if pickup_name == "float":
		if float_collected == true:
			return true
	if pickup_name == "map":
		if map_collected == true:
			return true
	if pickup_name == "glitch":
		if glitch_collected == true:
			return true
	if pickup_name == "fake_map":
		if fake_map_collected == true:
			return true
	return false
