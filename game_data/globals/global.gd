extends Node

## Global references for player and motion
var gekko : Gekko
var ui : UI
var current_movement_speed : float = 0.0
var player_dead : bool = false
var max_hp : int = 3
var current_hp : int = 3
var current_attack_damage : int = 1:
	set(v):
		current_attack_damage = v
		gekko.hurtbox.damage = v
var current_rank : int = 0
var stats:Dictionary
var parallax : ParallaxBG
var spawner : Spawner
var score: int =0

signal player_died
signal game_started
signal halted
signal resumed
signal boss_fight_started
signal boss_fight_ended

func change_hp(amnt : int):
	current_hp = clamp(current_hp + amnt, 0, max_hp)
	ui.set_hp_bar()

func reset_global():
	current_hp=max_hp
	score = 0

func reset_stats():
	for key in stats:
		stats[key] = 0

func halt():
	parallax.slow_background(0)
	gekko.disable()
	spawner.toggle_pause(true)
	enemies_pause()

func resume():
	parallax.reset_background()
	gekko.enable()
	spawner.toggle_pause(false)
	enemies_pause(false)

func enemies_pause(paused:bool = true):
	if paused:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.process_mode = Node.PROCESS_MODE_INHERIT
