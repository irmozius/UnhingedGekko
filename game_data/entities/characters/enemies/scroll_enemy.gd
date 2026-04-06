## Scrolling enemy class. Basic, non-boss enemies
class_name ScrollingEnemy
extends Enemy

func on_ready() -> void:
	fsm.add_state("Normal", normal_enter, normal_exit, normal_update, normal_pupdate)
	fsm.add_state("Knockback", knockback_enter, knockback_exit, knockback_update, knockback_pupdate)
	fsm.set_state("Normal")

func on_nonlethal_hit():
	fsm.set_state("Knockback")

## We should do something more interesting when they die, at some point

#region NormalState

func normal_enter():
	if anim:
		anim.play("walk")

func normal_exit():
	pass

func normal_update(_delta : float):
	pass

func normal_pupdate(delta: float):
	position.x -= speed * delta

#endregion

#region KnockbackState

func knockback_enter():
	anim.play("hurt")
	await get_tree().create_timer(0.3).timeout
	fsm.set_state("Normal")

func knockback_exit():
	pass

func knockback_update(_delta : float):
	pass

func knockback_pupdate(delta : float):
	position.x += knockback * delta

#endregion
