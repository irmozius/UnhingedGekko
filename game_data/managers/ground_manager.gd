class_name GroundManager
extends Node2D

var grounds : Array[Sprite2D] = []
var last_ground : Sprite2D
var first_ground : Sprite2D
@export var x_threshold : float = 256

func _ready() -> void:
	for i in get_children():
		grounds.append(i)
	last_ground = grounds[3]
	first_ground = grounds[0]
		
func move(speed : float):
	Global.current_movement_speed = speed
	for i : Sprite2D in grounds:
		i.position.x -= speed
		if last_ground.position.x < x_threshold:
			create_new_ground()

func create_new_ground():
	var new_ground : Sprite2D = last_ground.duplicate()
	add_child(new_ground)
	new_ground.position = Vector2(384,191)
	grounds.append(new_ground)
	last_ground = new_ground
	grounds.erase(first_ground)
	first_ground.queue_free()
	first_ground = grounds[0]
