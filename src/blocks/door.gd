extends StaticBody2D

var opened = true

@export var door_type: Type

enum Type {BLUE, YELLOW, GRAY}

func _ready() -> void:
	if door_type == Type.YELLOW:
		$Sprite2D.texture = load("res://assets/sprites/blocks/doors/yellow_door.png")
	elif door_type == Type.GRAY:
		$Sprite2D.texture = load("res://assets/sprites/blocks/doors/gray_door.png")
	await get_tree().create_timer(0.1).timeout
	if $Area2D.get_overlapping_bodies().size() == 0:
		$AnimationPlayer.play("closed")
		opened = false
		
func take_damage(damage):
	if door_type == Type.BLUE:
		open()
	elif door_type == Type.YELLOW and damage > 2:
		open()
	else:
		return
	
func open():
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("open")

func lock():
	door_type = Type.GRAY
	$Sprite2D.texture = load("res://assets/sprites/blocks/doors/gray_door.png")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if opened:
		$AnimationPlayer.play("close")
		opened = false
