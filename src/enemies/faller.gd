extends "res://src/scripts/enemy.gd"

var damage = 1
var falling = false

const FALLING_SPEED = 7000
const MOVEMENT_SPEED = 3000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not dead:
		if abs(global_position.x - player_pos.x) < 50:
			falling = true
			$AnimationPlayer.play("fall")
		if falling == true:
			velocity.y = FALLING_SPEED* delta
			velocity.x = sign(global_position.x - player_pos.x) * -MOVEMENT_SPEED * delta
		if is_on_floor():
			queue_free()
		move_and_slide()
		
func _process(delta: float) -> void:
	if not dead:
		var bodies = $HitBox.get_overlapping_bodies()
		for b in bodies:
			if b.has_method("take_damage"):
				b.take_damage(damage)
	elif dead:
		$AnimationPlayer.stop()
