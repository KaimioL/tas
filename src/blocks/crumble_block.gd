extends StaticBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $CrumbleTimer.time_left < 0.4:
		$Sprite2D.frame = 1
	if $CrumbleTimer.time_left < 0.3:
		$Sprite2D.frame = 2
	if $CrumbleTimer.time_left < 0.2:
		$Sprite2D.frame = 3
	if $CrumbleTimer.time_left < 0.1:
		$Sprite2D.frame = 4
	if $CrumbleTimer.time_left == 0:
		$Sprite2D.frame = 0


func _on_crumble_timer_timeout() -> void:
	$Sprite2D.hide()
	$CollisionShape2D.disabled = true
	$Cooldown.start()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$CrumbleTimer.start()


func _on_cooldown_timeout() -> void:
	$Sprite2D.show()
	$CollisionShape2D.disabled = false
