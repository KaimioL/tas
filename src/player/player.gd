extends CharacterBody2D
class_name Player

const SPEED = 100.0
const SLIDE_SPEED = 250
const JUMP_VELOCITY = -330.0
const BALL_JUMP_VELOCITY = -180.0
const AIR_FRICTION = 5
const GROUND_FRICTION = 10
const DAMAGE_BOOST = Vector2(-250, -250)
const BOOST_SPEED = 180
const BOOST_TIME = 0.8
const ACC = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_ground_last_frame = false
var coyote = false
var can_jump = true
var jump_buffer = false
var has_pinch = false
var looking_direction = 1
var in_wall = false
var hover = false
var has_hover = true
var max_velocity = 500
var aim = 0
var health = 3
var has_float = false
var command_lock = false
var shooting_buffer = false
var boost_direction = null
var boost_time_left = 0
var is_ball = false
var empty_body = null
var shot_charged = false

@export var control_locked = false
@onready var coyote_time = $CoyoteTime
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var camera = $Camera2D

var bullet_scene = preload("res://src/player/bullet.tscn")
var body_scene = preload("res://src/player/body.tscn")

signal shooted()
signal health_changed(health)

func _physics_process(delta):
	in_wall = false
	if Input.is_action_pressed("debug_button") and not Globals.paused:
		in_wall = true
	
	if Globals.glitch_collected:
		in_wall = true
		
	# Check for hover debug code
	if Input.is_action_pressed("up") and Input.is_action_pressed("down") and Input.is_action_pressed("left") and Input.is_action_pressed("right") and not Globals.paused:
		if not command_lock:
			hover = !hover
			if hover == false:
				$CanvasLayer/Label.text = "DebugHover: Disabled"
			if hover == true:
				$CanvasLayer/Label.text = "DebugHover: Enabled"
			$CanvasLayer/Label.show()
			$CanvasLayer/Timer.start()
		# Lock the command until player releases debug code
		command_lock = true
	else:
		command_lock = false
	
	# Check if player is inside a wall
	for i in $CollisionRayCasts.get_children():
		if i.is_colliding():
			in_wall = true

	if in_wall:
		disable_collisions()
	else:
		enable_collisions()
	
	if can_jump == false and (is_on_floor_check()):
		can_jump = true

	# Add the gravity.
	if not is_on_floor():
		if (in_wall or hover) and velocity.y + gravity * delta > 0:
			velocity.y = 0
		elif velocity.y < max_velocity:
			velocity.y += gravity * delta
	
	if not is_on_floor_check() and on_ground_last_frame:
		coyote_time.start()
		coyote = true
		
	if not on_ground_last_frame and is_on_floor_check():
		$LandingAudio.play()
	
	if hover and velocity.y > 0:
		velocity.y = 0
		
	# Handle jump.
	if jump_buffer and (is_on_floor_check() or coyote) and can_jump:
		velocity.y = JUMP_VELOCITY if not is_ball else BALL_JUMP_VELOCITY
		can_jump = false
		coyote = false
		jump_buffer = false
		$JumpAudio.play()
	
	# Stop jump velocity when jump not pressed
	if !Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y += 1000 * delta
	var h_direction = Vector2(0,0)
	var v_direction = Vector2(0,0)
	
	if not Globals.paused:
		h_direction = Input.get_axis("left", "right")
		v_direction = Input.get_axis("up", "down")
	
	# Update aim direction
	if not v_direction:
		aim = 0
	else:
		if v_direction == -1:
			aim = 2
		else:
			aim = 4
		if h_direction:
			aim -= 1
	$Sprites.aim = aim
	
	# Update horizontal velocity
	if h_direction and not control_locked:
		if is_on_floor_check() and h_direction != sign(velocity.x) and velocity.x != 0:
			velocity.x = 0
		velocity.x = move_toward(velocity.x, h_direction * SPEED, ACC)
		looking_direction = h_direction
		
	# Apply friction if there is no horizontal direction
	elif is_on_floor_check():
		velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
	elif (h_direction == 0 or h_direction != velocity.normalized().x) and not is_on_floor_check() and not control_locked:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
		
	# Update animation state
	if not $Sprites.state == "damage":
		if velocity.x != 0 and is_on_floor_check():
			$Sprites.state = "walk"
		else:
			$Sprites.state = "idle"
	
	if Globals.glitch_collected:
		velocity.y = 40
		
	on_ground_last_frame = is_on_floor_check()
	
	# Boost
	if boost_direction != null and boost_time_left > 0 and not is_on_floor_check():
		print(boost_time_left)
		velocity = BOOST_SPEED * boost_direction
		boost_time_left -= delta
	elif is_on_floor_check():
		boost_time_left = BOOST_TIME
		
	move_and_slide()

func _process(delta):
	$Sprites.scale.x = -1 if looking_direction == -1 else 1
	
	Signals.player_position.emit(global_position)
	

func _unhandled_input(event):
	if Globals.paused:
		return
		
	if event.is_action_pressed("jump"):
		if !is_on_floor_check() and Globals.booster_collected:
			if Input.get_vector("left", "right", "up", "down") == Vector2.ZERO:
				boost_direction = Vector2(0, -1)
			else:
				boost_direction = Input.get_vector("left", "right", "up", "down")
		else:
			jump_buffer = true
			jump_buffer_timer.start()	
	
	if event.is_action_released("jump"):
		boost_direction = null
	
	if event.is_action_pressed("hover"):
		if Globals.float_collected:
			hover = true
	
	if event.is_action_released("hover"):
		hover = false
	
	if event.is_action_pressed("shoot"):
		shot_charged = false
		$ChargeTimer.start()
		shoot("normal_bullet")
	
	if event.is_action_released("shoot"):
		if shot_charged:
			shoot("charge_bullet")
		shot_charged = false
		$ChargeTimer.stop()

	
	if event.is_action_pressed("pinch"):
		if Globals.pinch_collected:
			take_damage(0)
			
	if event.is_action_pressed("ball"):
		if not is_ball:
			$CollisionShape2D.shape.size = Vector2(11, 10)
			$TransformAnimation.play("ball")
			var body = body_scene.instantiate()
			body.position = position
			body.scale.x = -1 if looking_direction == -1 else 1
			empty_body = body
			add_child(body)
			$Sprites/Ball.frame = 0
			is_ball = true
		else:
			$CollisionShape2D.shape.size = Vector2(11, 30)
			$TransformAnimation.play("RESET")
			is_ball = false
			global_position = empty_body.global_position
			velocity = Vector2.ZERO
			empty_body.queue_free()
			

func disable_collisions():
	set_collision_mask_value(1, false)

func enable_collisions():
	if not get_collision_mask_value(1):
		set_collision_mask_value(1, true)
	
func is_on_floor_check() -> bool:
	if is_on_floor() or in_wall or hover:
		return true
	return false

func take_damage(damage):
	$HurtAudio.play()
	if $InvFrames.is_playing():
		return
	velocity = DAMAGE_BOOST * Vector2(looking_direction, 1)
	$InvFrames.play("inv_frames")
	$Sprites.state = "damage"
	health -= damage
	health_changed.emit(health)

func shoot(type):
	if $ShootingCooldown.is_stopped():
		$ShootingCooldown.start()
		shooting_buffer = false
		var bullet = bullet_scene.instantiate()
		if type == "normal_bullet":
			bullet.type = "normal"
		elif type == "charge_bullet":
			bullet.type = "rocket"
		bullet.position = position - Vector2(0, -2)
		add_child(bullet)
		shooted.emit("normal")
		
		if aim == 0:
			bullet.rotation = 0
			bullet.rotation += PI if looking_direction == -1 else 0
		elif aim == 1:
			bullet.rotation = -PI/4
			bullet.rotation -= PI/2 if looking_direction == -1 else 0
		elif aim == 2:
			bullet.rotation = -PI/2
		elif aim == 3:
			bullet.rotation = PI/4
			bullet.rotation += PI/2 if looking_direction == -1 else 0
		elif aim == 4:
			bullet.rotation = PI/2
	else:
		shooting_buffer = true

func booster():
	pass

func _on_timer_timeout() -> void:
	$CanvasLayer/Label.hide()


func _on_coyote_time_timeout():
	coyote = false
	can_jump = false

func _on_jump_buffer_timer_timeout():
	jump_buffer = false


func _on_inv_frames_animation_finished(anim_name: StringName) -> void:
	$Sprites.state = "idle"


func _on_charge_timer_timeout() -> void:
	shot_charged = true
