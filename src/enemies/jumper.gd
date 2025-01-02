extends "res://src/scripts/enemy.gd"

var damage = 1
var in_air = false

func physics_loop(delta: float) -> void:
	if not dead:
		if global_position.distance_to(player_pos) < 100:
			if is_on_floor() and not $AnimationPlayer.is_playing() and $JumpCooldown.is_stopped():
				$JumpCooldown.start()
				$AnimationPlayer.play("jump")
		if not is_on_floor():
			velocity.y += 300 * delta
		if is_on_floor():
			if in_air == true:
				$JumpAudio.play()
				in_air = false
				$Sprite2D.frame = 0
			velocity = velocity.move_toward(Vector2.ZERO, delta * 200)
		move_and_slide()

func process_loop(delta: float) -> void:
	if not dead:
		var bodies = $HitBox.get_overlapping_bodies()
		for b in bodies:
			if b.has_method("take_damage"):
				b.take_damage(damage)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump" and not dead:
		in_air = true
		var direction = 1 if global_position.x - player_pos.x < 0 else -1
		velocity = Vector2(100 * direction, -200)
		move_and_slide
