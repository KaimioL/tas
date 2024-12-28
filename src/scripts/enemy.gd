extends CharacterBody2D
class_name Enemy

@export var health: int

var dead = false
var player_pos = Vector2.ZERO

signal died

func _ready():
	Signals.player_position.connect(_player_position_changed)

func take_damage(damage):
	if not dead:
		$HitAnimation.play("hit")
		$HitAudio.play()
		health -= damage
		if health <= 0:
			died.emit()
			die()
		
func die():
	dead = true
	$HitAnimation.play("death")
	$CollisionShape2D.queue_free()
	await $HitAnimation.animation_finished
	queue_free()


func _player_position_changed(player_position) -> void:
	player_pos = player_position
