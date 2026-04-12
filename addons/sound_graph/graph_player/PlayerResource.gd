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

signal finished

@abstract func execute()

@abstract func get_type()

func _to_string() -> String:
	var str : String = get_type() + "\n"
	for i in descendants:
		str += i._to_string()
	return str
