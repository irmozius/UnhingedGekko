@tool
@abstract
class_name AudioNode extends GraphNode

signal deleted

@onready var graph_editor : Graph = get_parent()
var connected_by : Array[AudioNode]
var connected_to : Array[AudioNode]
var resource : PlayerResource

func execute():
	resource.execute()

func moved():
	if resource:
		resource.graph_pos = position_offset
	
func _enter_tree() -> void:
	position_offset_changed.connect(moved)

func spawn_descendants():
	var index : = 0
	if resource.descendants.size() == 0: return
	for dres : PlayerResource in resource.descendants:
		var dnode : AudioNode = is_descendant_already_spawned(dres)
		#var existing_node : AudioNode = is_descendant_already_spawned(dres)
		if !(dnode):
			dnode = graph_editor.load_node_from_resource(dres)
		graph_editor.add_connection(dnode.name, 0, name, index)
		index += 1
		
func _on_sound_deleted(node : AudioNode):
	connected_by.erase(node)
	resource.descendants.erase(node.resource)
	
func is_descendant_already_spawned(dres : PlayerResource) -> AudioNode:
	for i : AudioNode in connected_by:
		if i.resource == dres:
			return i
	return null

@abstract func load_values()
	
func pulse():
	var t : Tween = create_tween()
	modulate = Color.WHITE * 1.8
	t.tween_property(self, "modulate", Color.WHITE, 0.1)
