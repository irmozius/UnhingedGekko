extends Node2D

var speed : float = 200
var moving: bool = true
	
func _ready() -> void:
	Global.player_died.connect(func(): moving = false)

func _physics_process(delta: float) -> void:
	if !moving: return
	position.x -= speed * delta
	if global_position.x < -20:
		queue_free()
