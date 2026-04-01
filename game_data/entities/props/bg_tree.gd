extends Node2D

var speed : float = 200

func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	if global_position.x < -20:
		queue_free()
