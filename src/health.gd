extends HBoxContainer


func change_health(health):
	if health < 3:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
	if health < 2:
		$Sprite2D2.frame = 1
	else:
		$Sprite2D2.frame = 0
	if health < 1:
		$Sprite2D3.frame = 1
	else:
		$Sprite2D3.frame = 0
