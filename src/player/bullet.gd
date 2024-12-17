extends Area2D

var frame = 0
var shooting = false
var type = "normal"
var damage = 1

func _ready():
	if type == "charge" or type == "rocket":
		scale *= 2
		damage *= 3

func _process(delta: float) -> void:
	if $FrameTimer.is_stopped():
		global_position += Vector2(350 * delta, 0).rotated(rotation)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	explode()

func explode():
	if type == "rocket":
		$ExplosionArea.monitoring = true
	$CollisionShape2D.disabled = true
	$FrameTimer.start()

func _on_frame_timer_timeout() -> void:
	if $Sprite2D.frame + 2 > $Sprite2D.hframes:
		queue_free()
	else:
		$Sprite2D.frame += 1

func _on_explosion_area_body_entered(body: Node2D) -> void:
	var direction
	if global_position.x > body.global_position.x:
		direction = -1
	elif global_position.x < body.global_position.x:
		direction = 1
	else:
		direction = 0
	body.velocity += Vector2(400 * direction, -400)
	$ExplosionArea.queue_free()
