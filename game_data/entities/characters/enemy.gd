## Base Enemy class. Simply holds a speed value to move with,
## and a reference to a hitbox (optional).
class_name Enemy
extends Node2D

@export var speed : float = 1.0
@export var hitbox : Hitbox

var moving : bool = true


func _ready() -> void:
	## Setup connection to react to player dying, simply switching off movement once it occurs.
	Global.player_died.connect(func(): moving = false)
	if hitbox:
		hitbox.received_hit.connect(_on_hitbox_received_hit)

## One hit and dead!
func _on_hitbox_received_hit(_hurtbox : Hurtbox):
	die()

## We should do something more interesting when they die, at some point
func die():
	queue_free()
	
## Move left based on exported speed if movement is true.
func _physics_process(delta: float) -> void:
	if !moving: return
	position.x -= speed * delta
