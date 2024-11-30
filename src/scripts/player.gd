extends CharacterBody2D
class_name Player

const SPEED = 100.0
const SLIDE_SPEED = 250
const JUMP_VELOCITY = -330.0
const AIR_FRICTION = 10
const GROUND_FRICTION = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_ground_last_frame = false
var coyote = false
var can_jump = true
var jump_buffer = false
var slide_buffer = false
var wall_jump_lock = false
var slide_cooldown = false
var slide_direction = 0
var has_pinch = false
var looking_direction = 1
var in_wall = false
var hover = false
var has_slide = false
var has_wall_jump = false
var has_hover = true
var max_velocity = 500
var aim = 0
var health = 3
var paused = false
var has_float = false
@export var control_locked = false

@onready var bullet = $Bullet
@onready var coyote_time = $CoyoteTime
@onready var jump_buffer_timer = $JumpBufferTimer
#@onready var slide_timer = $SlideTimer
#@onready var slide_buffer_timer = $SlideBufferTimer
#@onready var wall_jump_timer = $WallJumpTimer
#@onready var left_wall_raycast = $WallRaycasts/LeftWallRaycast
#@onready var right_wall_raycast = $WallRaycasts/RightWallRaycast
#@onready var slide_cooldown_timer = $SlideCooldownTimer
@onready var camera = $Camera2D

signal shooted
signal health_changed(health)

func _physics_process(delta):
	if paused:
		return
	in_wall = false
	#if Input.is_action_pressed("debug_button"):
		#in_wall = true

	for i in $CollisionRayCasts.get_children():
		if i.is_colliding():
			in_wall = true
	if in_wall:
		disable_collisions()
	else:
		enable_collisions()
	
	if can_jump == false and (is_on_floor_check()):
		can_jump = true
		 
	#if slide_buffer == true and is_on_floor_check() and slide_direction == 0 and not slide_cooldown:
		#slide_buffer = false
		#slide_timer.start()
		#slide_direction = looking_direction	
		#$SlideAudio.play()
	# Add the gravity.
	if not is_on_floor():
		if (in_wall or hover) and velocity.y + gravity * delta > 0:
			velocity.y = 0
		elif velocity.y < max_velocity:
			velocity.y += gravity * delta
		
	if not is_on_floor_check() and on_ground_last_frame:
		coyote_time.start()
		coyote = true
	
	if hover and velocity.y > 0:
		velocity.y = 0
	
	# Handle jump.
	if jump_buffer and (is_on_floor_check() or coyote) and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		coyote = false
		jump_buffer = false
		$JumpAudio.play()
	#elif jump_buffer and left_wall_raycast.is_colliding():
		#wall_jump(1)
	#elif jump_buffer and right_wall_raycast.is_colliding():
		#wall_jump(-1)
		
	if !Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y += 1000 * delta

	on_ground_last_frame = is_on_floor_check()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var v_direction = Input.get_axis("up", "down")
	if not v_direction:
		aim = 0
	else:
		if v_direction == -1:
			aim = 2
		else:
			aim = 4
		if direction:
			aim -= 1
	$Sprites.aim = aim
	if direction and slide_direction == 0 and not control_locked:
		if (not is_on_floor_check() and !wall_jump_lock and direction != sign(velocity.x)) or is_on_floor_check():
			velocity.x = direction * SPEED
		looking_direction = direction
	elif slide_direction != 0:
		velocity.x = slide_direction * SLIDE_SPEED
	elif is_on_floor_check():
		velocity.x = move_toward(velocity.x, 0, GROUND_FRICTION)
	elif direction == 0 and not is_on_floor_check() and not wall_jump_lock and not control_locked:
		velocity.x = move_toward(velocity.x, 0, AIR_FRICTION)
		
	
	if velocity.x != 0 and is_on_floor_check():
		if slide_direction != 0:
			$AnimationPlayer.play("slide")
		else:
			$Sprites.state = "walk"
	else:
		$Sprites.state = "idle"
	

	
	move_and_slide()

func _process(delta):
	$Sprites.scale.x = -1 if looking_direction == -1 else 1
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
	Signals.player_position.emit(global_position)
	

func _unhandled_input(event):
	#if event.is_action_pressed("slide") and has_slide:
		#slide_buffer = true
		#slide_buffer_timer.start()chara
	
	if event.is_action_pressed("jump"):
		jump_buffer = true
		jump_buffer_timer.start()
	
	if event.is_action_pressed("hover"):
		if has_float:
			hover = true
	
	if event.is_action_released("hover"):
		hover = false
	
	if event.is_action_pressed("shoot"):
		bullet.fire()
		shooted.emit()
		
	if event.is_action_pressed("pinch"):
		if has_pinch:
			take_damage(0)
	

func wall_jump(direction):
	if has_wall_jump:
		wall_jump_lock = true
		jump_buffer = false
		#wall_jump_timer.start()
		slide_direction = 0
		velocity.x = direction * SPEED
		velocity.y = JUMP_VELOCITY
		$JumpAudio.play()

func _on_coyote_time_timeout():
	coyote = false
	can_jump = false

func _on_jump_buffer_timer_timeout():
	jump_buffer = false


func _on_slide_timer_timeout():
	slide_direction = 0
	slide_cooldown = true
	#slide_cooldown_timer.start()


func _on_slide_buffer_timer_timeout():
	slide_buffer = false


func _on_wall_jump_timer_timeout():
	wall_jump_lock = false


func _on_slide_cooldown_timer_timeout():
	slide_cooldown = false

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
	if $InvFrames.is_playing():
		return
	velocity = Vector2(-200*looking_direction, -250)
	$InvFrames.play("inv_frames")
	health -= damage
	health_changed.emit(health)
	
func pickup_collected(pickup_name):
	if pickup_name == "pinch":
		has_pinch = true
	elif pickup_name == "float":
		has_float = true
