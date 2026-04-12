@tool
class_name SoundGraph extends Resource

@export var graph : Array[PlayerResource]
@export var output_position : Vector2

func add_resource(resource : PlayerResource, root_node : Node):
	resource.root_node = root_node
	graph.append(resource)

func _to_string() -> String:
	var str : String
	for i : PlayerResource in graph:
		str += i._to_string()
	return str
