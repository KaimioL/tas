extends Node2D

var state = "idle"
var aim = 0
var frame = 0
var shoot_frame = 0
var bullet_frame = 0
var ball_frame = 0
var shooting = false
var bullet: Sprite2D
var damage_frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Ball.frame = 0 + ball_frame
	if state == "idle":
		$Legs.frame = 0
	if state == "walk":
		$Legs.frame = 8 + frame
	if state == "damage":
		$Legs.frame = 16 + damage_frame
	if frame % 8 < 4:
		$Torso.position.y = -15
	else:
		$Torso.position.y = -14
	$Torso.frame = aim * 4 + shoot_frame

func _on_frame_timer_timeout() -> void:
	frame += 1
	if damage_frame == 0:
		damage_frame == 1
	if frame >= 8:
		frame = 0
	if shooting:
		shoot_frame += 1
		if shoot_frame > 3:
			shooting = false
			shoot_frame = 0
	if state == "walk":
		ball_frame += 1
		if ball_frame >= 6:
			ball_frame = 0

func _on_player_shooted(bullet) -> void:
	shooting = true
