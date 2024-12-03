extends Node2D

var state = "idle"
var aim = 0
var frame = 0
var shoot_frame = 0
var bullet_frame = 0
var shooting = false
var bullet: Sprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "idle":
		$Legs.frame = 0
	elif state == "walk":
		$Legs.frame = 8 + frame
	if frame % 8 < 4:
		$Torso.position.y = 1
	else:
		$Torso.position.y = 0
	$Torso.frame = aim * 4 + shoot_frame

func _on_frame_timer_timeout() -> void:
	frame += 1
	if frame >= 8:
		frame = 0
	if shooting:
		shoot_frame += 1
		if shoot_frame > 3:
			shooting = false
			shoot_frame = 0

func _on_player_shooted() -> void:
	shooting = true
