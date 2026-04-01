class_name Spawner
extends Node2D

@export var obstacles : Array[PackedScene]

func spawn():
	var obj = obstacles.pick_random()
	
