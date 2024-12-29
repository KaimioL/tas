extends CharacterBody2D

var current_state = States.IDLE

enum States {IDLE}

var rng = RandomNumberGenerator.new()
var spore_scene = load("res://src/enemies/bosses/spore.tscn")

func _process(delta: float) -> void:
	if rng.randi_range(1, 5) == 1:
		var spore = spore_scene.instantiate()
		spore.position.x = rng.randf_range(-200, 200)
		add_child(spore)
