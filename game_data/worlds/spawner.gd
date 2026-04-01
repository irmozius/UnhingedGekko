class_name Spawner
extends Node2D

@export var obstacles : Array[PackedScene]
@export var min_time : float = 4.0
@export var max_time : float = 8.0
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(randf_range(min_time, max_time))

func spawn():
	if Global.player_dead: return
	var obj : Enemy = obstacles.pick_random().instantiate()
	add_child(obj)
	obj.global_position = global_position

func _on_timer_timeout() -> void:
	spawn()
	timer.start()
