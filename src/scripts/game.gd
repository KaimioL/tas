extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"

const SAVE_PATH = "user://example_save_data.sav"
const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")

var collectibles: int:
	set(count):
		collectibles = count
		%CollectibleCount.text = "%d/6" % count

var events: Array[String]
var starting_position

var starting_map = "space_station_3.tscn"
var custom_run = false

signal pickup_screen_closed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_pos = $Player.position
	starting_position = $Player.position
	
	Globals.got_pickup.connect(_on_got_pickup)
	
	set_player($Player)
	if FileAccess.file_exists(SAVE_PATH):
		# If save data exists, load it using MetSys SaveManager.
		var save_manager := SaveManager.new()
		save_manager.load_from_text(SAVE_PATH)
		# Assign loaded values.
		collectibles = save_manager.get_value("collectible_count")
		events.assign(save_manager.get_value("events"))
		player.abilities.assign(save_manager.get_value("abilities"))
		
		if not custom_run:
			var loaded_starting_map: String = save_manager.get_value("current_room")
			if not loaded_starting_map.is_empty(): # Some compatibility problem.
				starting_map = loaded_starting_map
	else:
		# If no data exists, set empty one.
		MetSys.set_save_data()
	
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	$Player.position = player_pos
	
	load_room(starting_map)
	add_module("RoomTransitions.gd")
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("map"):
		#print($UI/MapWindow.visible)
		#if not $UI/MapWindow.visible:
			#print("aaaa")
			#$UI/MapWindow.hide()
			#$Player.paused = false
		#else:
			#$UI/MapWindow.show()
			#$Player.paused = true
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func init_room():
	MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	
	
func _on_got_pickup(pickup_name: String) -> void:
	$Player.control_locked = true
	$UI/PickupScreen.show()
	if pickup_name == "pinch":
		$UI/PickupScreen/Label.text = "Pinch"
		$UI/PickupScreen/Label2.text = "Press C button."
		$UI/PickupScreen/Timer.start()
	if pickup_name == "float":
		$UI/PickupScreen/Label.text = "Hover Boots"
		$UI/PickupScreen/Label2.text = "Press V button."
		$UI/PickupScreen/Timer.start()
	if pickup_name == "map":
		$UI/PickupScreen/Label.text = "True Map"
		$UI/PickupScreen/Label2.text = "Press D button to switch between map modes."
		$UI/PickupScreen/Timer.start()
	if pickup_name == "glitch":
		$UI/PickupScreen/Label.text = "What"
		$UI/PickupScreen/Label2.text = ""
		$UI/PickupScreen/Timer.start()

func _on_pickup_screen_closed() -> void:
	$Player.control_locked = false
	if Globals.glitch_collected:
		ending()
	pickup_screen_closed.emit()


func _on_player_health_changed(health: Variant) -> void:
	$UI/Health.change_health(health)
	
	if health == 0:
		die()
		

func die():
	$Player.health = 3
	var prev_room = MetSys.get_current_room_instance()
	await load_room(starting_map)
	prev_room.queue_free()
	$Player.position = starting_position
	
	$UI/Health.change_health(3)

func ending():
	if not $EndingTimer.is_stopped():
		return
	$EndingMusic.play()
	$EndingTimer.start()
	

func _on_ending_timer_timeout() -> void:
	Globals.ending += 1
	if Globals.ending > 8:
		AudioServer.get_bus_effect(0,0).drive += 0.1
	if Globals.ending > 12:
		get_tree().quit()
