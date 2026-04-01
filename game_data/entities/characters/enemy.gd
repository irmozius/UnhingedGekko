class_name Enemy
extends Node2D

@export var speed : float = 1.0
@export var hitbox : Hitbox

var moving : bool = true

func _ready() -> void:
	Global.player_died.connect(func(): moving = false)
	if hitbox:
		hitbox.received_hit.connect(_on_hitbox_received_hit)

func _on_hitbox_received_hit(hurtbox : Hurtbox):
	queue_free()

func _physics_process(delta: float) -> void:
	if !moving: return
	position.x -= speed * delta
