class_name BossEnemy
extends Enemy

@export var player_x : int = 50
@export var hurtbox_col :  CollisionShape2D

func on_ready():
	fsm.add_state("Approach", approach_enter, approach_exit, approach_update, approach_pupdate)
	fsm.add_state("Idle", idle_enter, idle_exit, idle_update, idle_pupdate)
	fsm.add_state("Attack", attack_enter, attack_exit, attack_update, attack_pupdate)
	fsm.add_state("Hurt", hurt_enter, hurt_exit, hurt_update, hurt_pupdate)
	fsm.add_state("Retreat", retreat_enter, retreat_exit, retreat_update, retreat_pupdate)
	fsm.set_state("Approach")
	Global.parallax.slow_background(-3)
	
func on_nonlethal_hit():
	print('hit')
	fsm.set_state("Hurt")

func on_death():
	Global.parallax.reset_background()

func _on_resume():
	fsm.set_state("Approach")

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
	if global_position.x < player_x:
		fsm.set_state("Attack")
	

#endregion

#region IdleState

func idle_enter():
	if anim:
		anim.play("walk")
	await get_tree().create_timer(randf_range(1,3)).timeout
	fsm.set_state("Approach")
	
func idle_exit():
	pass

func idle_update(_delta : float):
	pass
	
func idle_pupdate(_delta : float):
	pass
	

#endregion

#region AttackState

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

#region HurtState

func hurt_enter():
	anim.play("hurt")
	await get_tree().create_timer(0.3).timeout
	fsm.set_state("Retreat")

func hurt_exit():
	pass

func hurt_update(_delta : float):
	pass

func hurt_pupdate(delta : float):
	position.x += 60 * delta

#endregion

#region RetreatState

func retreat_enter():
	anim.play_backwards("walk")

func retreat_exit():
	pass

func retreat_update(_delta : float):
	pass

func retreat_pupdate(delta : float):
	if global_position.x > 170:
		fsm.set_state("Idle")
	else:
		position.x += (speed * 0.6) * delta

#endregion
