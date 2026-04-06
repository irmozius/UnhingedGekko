## Class to spawn obstacles/enemies. Has an exported array to choose a random
## obstacle. Uses a timer to space out spawns.
class_name Spawner
extends Node2D

## Array of enemy/obstacle scenes.
@export var enemies : Array[PackedScene]
@export var bosses : Array[PackedScene]
## Min/max time between spawns.
@export var min_time : float = 4.0
@export var max_time : float = 8.0
@onready var enem_timer: Timer = $ScrollerTimer
@onready var boss_timer: Timer = $BossTimer

func _ready() -> void:
	enem_timer.start(randf_range(min_time, max_time))
	boss_timer.start(randf_range(min_time * 6, max_time * 6))

## Make a new enemy, and position it.
func spawn(boss : bool = false):
	if Global.player_dead: return
	var enem : Enemy = enemies.pick_random().instantiate() if !boss else bosses.pick_random().instantiate()
	add_child(enem)
	if boss:
		enem.died.connect(_on_boss_died, CONNECT_ONE_SHOT)
	enem.global_position = global_position

func _on_etimer_timeout() -> void:
	spawn()
	enem_timer.start()

func _on_btimer_timeout() -> void:
	spawn(true)

func _on_boss_died():
	boss_timer.start(randf_range(min_time * 5, max_time * 5))
