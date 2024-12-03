extends Area2D

var frame = 0
var shooting = false

func _process(delta: float) -> void:
	if frame > 4:
		hide()
		$ShootTimer.stop()
		shooting = false
	else:
		$Bullet.frame = frame
	for c in get_overlapping_bodies():
		if c.has_method("take_damage") and shooting:
			c.take_damage(1)

func fire():
	if shooting != true:
		$ShootingAudio.play()
		show()
		shooting = true
		frame = 0
		$ShootTimer.start()

	
func _on_shoot_timer_timeout() -> void:
	frame += 1
