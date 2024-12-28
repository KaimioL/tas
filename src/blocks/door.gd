extends StaticBody2D

var opened = true

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	if $Area2D.get_overlapping_bodies().size() == 0:
		$AnimationPlayer.play("closed")
		opened = false
		
func take_damage(damage):
	open()
	
func open():
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if opened:
		$AnimationPlayer.play("close")
		opened = false
