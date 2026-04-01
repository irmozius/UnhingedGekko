## Class to spawn background trees and set their movement speeds, for fake parallax.
class_name FakeParallax
extends Node2D

## Tree scene
const BG_TREE = preload("uid://b8d56wreq86qy")

## Timers for spawning
@onready var close_timer: Timer = $CloseTimer
@onready var mid_timer: Timer = $MidTimer
@onready var far_timer: Timer = $FarTimer

## Root nodes for parallax
@onready var close_root: Node2D = $Close
@onready var mid_root: Node2D = $Mid
@onready var far_root: Node2D = $Far


func _ready() -> void:
	## Spawn first trees and start timers
	spawn_tree("close")
	spawn_tree("mid")
	spawn_tree("far ")
	close_timer.start(randf_range(0.1,0.4))
	mid_timer.start(randf_range(0.2,0.5))
	far_timer.start(randf_range(0.3,0.8))

## Callback for tree spawning. Takes a string parameter to decide
## tree size, layer and speed.
func spawn_tree(dis : String):
	var tree : Node2D = BG_TREE.instantiate()
	var sprite : Sprite2D = tree.get_child(0)
	match dis:
		"close":
			close_root.add_child(tree)
			tree.speed = 140
		"mid":
			mid_root.add_child(tree)
			sprite.scale.y = 0.8
			tree.speed = 90
		"far":
			far_root.add_child(tree)
			sprite.scale.y = 1.0
			tree.speed = 60
	tree.global_position = global_position

## These three functions respond to the three different timers,
## spawning a relevant tree and restarting the timer.
func _on_close_timer_timeout() -> void:
	if Global.player_dead: return
	spawn_tree("close")
	close_timer.start(randf_range(0.5,1.2))

func _on_mid_timer_timeout() -> void:
	if Global.player_dead: return
	spawn_tree("mid")
	mid_timer.start(randf_range(1.2,3))

func _on_far_timer_timeout() -> void:
	if Global.player_dead: return
	spawn_tree("far")
	far_timer.start(randf_range(2,4))
