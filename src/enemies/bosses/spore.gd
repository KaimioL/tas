extends CharacterBody2D
const VER_SPEED = 100
const DAMAGE = 1

var rng = RandomNumberGenerator.new()

var hor_speed = rng.randi_range(0, 100)
var hor_acc = rng.randi_range(3, 30)
var hor_max_speed = rng.randi_range(50, 150)
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr = [1, -1]
	direction = arr.pick_random()
	velocity.y = VER_SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = hor_speed
	hor_speed += direction * hor_acc
	if hor_speed > hor_max_speed:
		direction = -1
	elif hor_speed < -hor_max_speed:
		direction = 1
	var collision = move_and_collide(velocity * delta)
	
	if collision != null:
		if collision.get_collider().has_method("take_damage"):
			collision.get_collider().take_damage(DAMAGE)
		queue_free()

func take_damage(damage):
	queue_free()
