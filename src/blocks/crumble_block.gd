extends StaticBody2D

var alive = true
var frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.frame = frame
	if frame > 1:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
		
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding() or $RayCast2D3.is_colliding():
		$RayCast2D.enabled = false
		$RayCast2D2.enabled = false
		$RayCast2D3.enabled = false
		
		
		$CrumbleTimer.start()
		$Sprite2D.show()
		get_parent().remove_graphics_tile(global_position)

func _ready() -> void:
	$Sprite2D.hide()

func _on_crumble_timer_timeout() -> void:
	if alive:
		frame += 1
		if frame == $Sprite2D.hframes - 1:
			$CrumbleTimer.stop()
			die()
			alive = false
	else:
		frame -= 1
		if frame == 0:
			$CrumbleTimer.stop()
			alive = true
			$RayCast2D.enabled = true
			$RayCast2D2.enabled = true
			$RayCast2D3.enabled = true
			
	
func die():
	alive = false
	$Sprite2D.hide()
	$Cooldown.start()



func _on_cooldown_timeout() -> void:
	$Sprite2D.show()
	$CrumbleTimer.start()
