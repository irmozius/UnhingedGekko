## Base Enemy class. Simply holds a speed value to move with,
## and a reference to a hitbox (optional).
class_name Enemy
extends Node2D

@export var speed : float = 1.0
@export var hitbox : Hitbox
@export var hp: int
@export var entity_name: String
var moving : bool = true


func _ready() -> void:
	## Setup connection to react to player dying, simply switching off movement once it occurs.
	Global.player_died.connect(func(): moving = false)
	if hitbox:
		hitbox.received_hit.connect(_on_hitbox_received_hit)
   
## One hit and dead!
func _on_hitbox_received_hit(_hurtbox : Hurtbox):
	take_damage(_hurtbox.damage)
	

## We should do something more interesting when they die, at some point
func die():
	if has_node("Hurtbox"):
		$Hurtbox.queue_free()
	hitbox.queue_free() #safety
	await play_death_animation()
	update_stats()
	queue_free()
	
## Move left based on exported speed if movement is true.
func _physics_process(delta: float) -> void:
	if !moving: return
	position.x -= speed * delta

func take_damage(amount):
	hp -= amount
	if hp<=0:
		die()

func play_death_animation():
	var anim_node= get_node_or_null("AnimationPlayer")
	if anim_node:
		anim_node.play("death")
		await anim_node.animation_finished
	# This is so that we can display in diedscreen later
func update_stats():
	Global.stats[entity_name] = Global.stats.get(entity_name, 0) + 1
	#print(Global.stats)
