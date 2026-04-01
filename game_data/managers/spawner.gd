## Class to spawn obstacles/enemies. Has an exported array to choose a random
## obstacle. Uses a timer to space out spawns.
class_name Spawner
extends Node2D

## Array of enemy/obstacle scenes.
@export var obstacles : Array[PackedScene]
## Min/max time between spawns.
@export var min_time : float = 4.0
@export var max_time : float = 8.0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(randf_range(min_time, max_time))

## Make a new enemy, and position it.
func spawn():
	if Global.player_dead: return
	var obj : Enemy = obstacles.pick_random().instantiate()
	add_child(obj)
	obj.global_position = global_position

func _on_timer_timeout() -> void:
	spawn()
	timer.start()
