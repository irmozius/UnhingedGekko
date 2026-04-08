## Base Enemy class. Simply holds a speed value to move with,
## and a reference to a hitbox (optional).
@abstract class_name Enemy
extends Node2D

signal died

var fsm = FunctionalStateMachineGDScript.new()

@export var speed : float = 1.0
@export var hitbox : Hitbox
@export var hp: int
@export var entity_name: String
@export var anim : AnimationPlayer
@export var hurtbox : Hurtbox
@export var knockback: int = 200
@export var level: int =1

func _ready() -> void:
	## Setup connection to react to player dying, simply switching off movement once it occurs.
	Global.player_died.connect(func(): disable())
	Global.halted.connect(_on_game_halted)
	fsm.add_state("Dead", dead_enter, dead_exit, dead_update, dead_pupdate)
	fsm.add_state("Disabled", disabled_enter, disabled_exit, disabled_update, disabled_pupdate)
	on_ready()
	if hitbox:
		print(hitbox)
		hitbox.received_hit.connect(_on_hitbox_received_hit)
 
@abstract func on_ready()
#This is so we can pause their processes
func _enter_tree() -> void:
	add_to_group("enemy")

## One hit and dead!
func _on_hitbox_received_hit(attacking_hurtbox : Hurtbox):
	take_damage(attacking_hurtbox.damage)

func _on_game_halted():
	fsm.set_state("Disabled")
	
func take_damage(amount):
	hp -= amount
	print(amount)
	if hp<=0:
		die()
	else:
		on_nonlethal_hit()

@abstract func on_nonlethal_hit()

## We should do something more interesting when they die, at some point
func die():
	died.emit()
	fsm.set_state("Dead")
	on_death()
	
@abstract func on_death()

func disable():
	fsm.set_state("Disabled")

func _process(delta: float) -> void:
	fsm.update(delta)
	
## Move left based on exported speed if movement is true.
func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)

func play_death_animation():
	if anim:
		anim.play("death")
		await anim.animation_finished

	# This is so that we can display in diedscreen later
func update_stats():
	Global.score = Global.score + (level * 100)
	#update score UI
	var score_node = get_tree().current_scene.get_node_or_null("%Score")
	if score_node:
		score_node.text = str(Global.score)
		score_node.pop_score()
	Global.stats[entity_name] = Global.stats.get(entity_name, 0) + 1
	#print(Global.stats)



#region DeadState

func dead_enter():
	if hurtbox:
		hurtbox.queue_free()
	hitbox.queue_free() #safety
	update_stats()
	await play_death_animation()
	queue_free()

func dead_exit():
	pass

func dead_update(_delta : float):
	pass

func dead_pupdate(delta : float):
	position.x += 30 * delta

#endregion

#region DisabledState

func disabled_enter():
	pass

func disabled_exit():
	pass

func disabled_update(_delta : float):
	pass

func disabled_pupdate(_delta : float):
	pass

#endregion
