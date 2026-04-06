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
var stats:Dictionary

signal player_died
signal game_started

func change_hp(amnt : int):
	current_hp = clamp(current_hp + amnt, 0, max_hp)
	ui.set_hp_lab()

func reset_stats():
	for key in stats:
		stats[key] = 0
