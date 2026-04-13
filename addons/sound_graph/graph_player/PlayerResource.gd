@tool
@abstract
class_name PlayerResource extends Resource

var root_node : Node:
	set(n):
		root_node = n
		for res in descendants:
			res.root_node = n

@export var descendants : Array[PlayerResource] = []:
	set(d):
		descendants = d
		#print(descendants)
@export var graph_pos : Vector2
var node : AudioNode
var audio_bus : String = "":
	set(v):
		audio_bus = v
		if descendants:
			for i : PlayerResource in descendants:
				i.audio_bus = audio_bus

signal finished

@abstract func execute()

@abstract func get_type()

func _to_string() -> String:
	var str : String = get_type() + "\n"
	for i in descendants:
		str += i._to_string()
	return str
