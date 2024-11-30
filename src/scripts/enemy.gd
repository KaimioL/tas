extends CharacterBody2D
class_name Enemy

@export var health: int

var dead = false

signal died

func take_damage(damage):
	if $HitTimer.is_stopped() and not dead:
		$HitAnimation.play("hit")
		$HitAudio.play()
		$HitTimer.start()
		health -= damage
		if health <= 0:
			died.emit()
			die()
		
func die():
	dead = true
	$HitAnimation.play("death")
	await $HitAnimation.animation_finished
	queue_free()
