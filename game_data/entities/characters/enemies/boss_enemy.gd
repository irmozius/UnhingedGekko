class_name BossEnemy
extends Enemy

@export var player_detect_area : Area2D
@export var hurtbox_col : CollisionShape2D

func on_ready():
	fsm.add_state("Approach", approach_enter, approach_exit, approach_update, approach_pupdate)
	fsm.add_state("Attack", attack_enter, attack_exit, attack_update, attack_pupdate)
	fsm.add_state("Hurt", hurt_enter, hurt_exit, hurt_update, hurt_pupdate)
	fsm.add_state("Retreat", retreat_enter, retreat_exit, retreat_update, retreat_pupdate)
	fsm.set_state("Approach")
	
func on_nonlethal_hit():
	pass

func activate_attack():
	hurtbox_col.disabled = false
	await get_tree().create_timer(0.1).timeout
	hurtbox_col.disabled = true

#region ApproachState

func approach_enter():
	if anim:
		anim.play("walk")

func approach_exit():
	pass

func approach_update(_delta : float):
	pass

func approach_pupdate(delta : float):
	position.x -= speed * delta
	var cols : Array[Node2D] = player_detect_area.get_overlapping_bodies()
	for i in cols:
		if i is Gekko:
			fsm.set_state("Attack")
	

#endregion

#region ApproachState

func attack_enter():
	anim.play("attack")
	await anim.animation_finished
	fsm.set_state("Retreat")

func attack_exit():
	pass

func attack_update(_delta : float):
	pass

func attack_pupdate(_delta : float):
	pass

#endregion

#region ApproachState

func hurt_enter():
	pass

func hurt_exit():
	pass

func hurt_update(_delta : float):
	pass

func hurt_pupdate(_delta : float):
	pass

#endregion

#region ApproachState

func retreat_enter():
	pass

func retreat_exit():
	pass

func retreat_update(_delta : float):
	pass

func retreat_pupdate(delta : float):
	if global_position.x > 190:
		fsm.set_state("Approach")
	else:
		position.x += (speed * 0.6) * delta

#endregion
