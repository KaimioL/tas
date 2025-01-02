extends CharacterBody2D
class_name Enemy

const HIT_PAUSE_FRAMES = 4

@export var health: int

var dead = false
var player_pos = Vector2.ZERO
var hit_pause_remaining_frames = 0

signal died

func _ready():
	Signals.player_position.connect(_player_position_changed)

func _physics_process(delta: float) -> void:
	if hit_pause_remaining_frames > 0:
		hit_pause_remaining_frames -= 1
		return
	physics_loop(delta)
	
func _process(delta: float) -> void:
	if hit_pause_remaining_frames > 0:
		return
	process_loop(delta)

func physics_loop(delta):
	return

func process_loop(delta):
	return

func take_damage(damage):
	if not dead:
		hit_pause_remaining_frames = HIT_PAUSE_FRAMES
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
