extends StaticBody2D

var frame = 0
var alive = true
var crumbling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.frame = frame
	if frame > 0:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false


func _on_timer_timeout() -> void:
	if alive:
		frame += 1
		if frame == $Sprite2D.hframes - 1:
			$Timer.stop()
			die()
			alive = false
	else:
		frame -= 1
		if frame == 0:
			$Timer.stop()
			alive = true

func die():
	alive = false
	$Sprite2D.hide()
	$Cooldown.start()

func _on_cooldown_timeout() -> void:
	$Sprite2D.show()
	$Timer.start()

func take_damage(damage):
	$Timer.start()
	$Sprite2D.show()
	get_parent().remove_graphics_tile(global_position)
