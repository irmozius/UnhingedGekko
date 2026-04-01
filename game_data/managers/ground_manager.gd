## Class to manage the ground movement.
class_name GroundManager
extends Node2D

## Array of all ground sprites
var grounds : Array[Sprite2D] = []
var last_ground : Sprite2D
var first_ground : Sprite2D

## Leftmost point for new grounds before spawning another
@export var x_threshold : float = 256

func _ready() -> void:
	## Fill references
	for i in get_children():
		grounds.append(i)
	last_ground = grounds[3]
	first_ground = grounds[0]

## Move left and check sprite positions
func move(speed : float):
	Global.current_movement_speed = speed
	for i : Sprite2D in grounds:
		i.position.x -= speed
		if last_ground.position.x < x_threshold:
			create_new_ground()

## Spawn a new ground sprite and delete the first
func create_new_ground():
	var new_ground : Sprite2D = last_ground.duplicate()
	add_child(new_ground)
	new_ground.position = Vector2(384,191)
	grounds.append(new_ground)
	last_ground = new_ground
	grounds.erase(first_ground)
	first_ground.queue_free()
	first_ground = grounds[0]
