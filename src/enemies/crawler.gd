extends "res://src/scripts/enemy.gd"

@export var direction = 1
@export var speed = 700

var wait_frames = 0
var damage = 1

func _physics_process(delta: float) -> void:
	if not dead:
		if wait_frames < 2:
			wait_frames += 1
			return
		velocity = Vector2(1, 0).rotated(rotation) * speed * delta
		up_direction = Vector2(0, -1).rotated(rotation)
		move_and_slide()
		if not $RayCast2D.is_colliding():
			wait_frames = 0
			rotation += PI/2 * direction
			position += Vector2(5, 0).rotated(rotation)
		if is_on_wall():
			wait_frames = 0
			rotation += PI/2 * -direction
			position += Vector2(15, 0).rotated(rotation)
		var bodies = $HitBox.get_overlapping_bodies()
		for b in bodies:
			if b.has_method("take_damage"):
				b.take_damage(damage)

func _on_timer_timeout() -> void:
	$Sprite2D.flip_h = not $Sprite2D.flip_h
