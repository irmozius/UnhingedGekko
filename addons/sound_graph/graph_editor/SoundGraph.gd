@tool
class_name SoundGraph extends Resource

@export var graph : Array[PlayerResource]
@export var output_position : Vector2

func add_resource(resource : PlayerResource, root_node : Node, bus : String):
	print(resource.audio_bus)
	resource.root_node = root_node
	#resource.audio_bus = bus
	graph.append(resource)

func _to_string() -> String:
	var str : String
	for i : PlayerResource in graph:
		str += i._to_string()
	return str
