
@tool
class_name Graph extends GraphEdit

@export var node_place_menu_scene : PackedScene
@onready var output_node : OutputNode = $%Output

var RES_NODE_MAP : Dictionary[String, PackedScene] = {
	"SamplePlayer": load("uid://vkwwrhhth385"),
	"Random": load("uid://b85hs6lw12tjj"),
	"Delay": load("uid://cqrre8omr7t57"),
	"Sequence": load("uid://e7t050olymjx"),
	"Poly": load("uid://cxawudpw0ha3n"),
	"Repeat": load("uid://cyg8tguf7wwxg")
}

var node_place_menu : NodePlaceMenu
var output_connections : Array[AudioNode]
var graph_resource : SoundGraph = SoundGraph.new()

func _ready() -> void:
	clear_graph()

func play_graph() -> void:
	for node : AudioNode in output_connections:
		node.execute()
		
func clear_graph():
	graph_resource = SoundGraph.new()
	graph_resource.resource_local_to_scene = true
	output_connections.clear()
	clear_connections()
	for node in get_children():
		if node is AudioNode:
			if !(node is OutputNode):
				node.queue_free()

func load_graph(graph : SoundGraph):
	clear_graph()
	output_node.position_offset = graph.output_position
	graph_resource = SoundGraph.new()
	#graph_resource.resource_local_to_scene = true
	for i : PlayerResource in graph.graph:
		var node : AudioNode = load_node_from_resource(i)
		add_connection(node.name, 0, output_node.name, 0)

func load_node_from_resource(resource: PlayerResource) -> AudioNode:
	var node : AudioNode = RES_NODE_MAP[resource.get_type()].instantiate()
	add_child(node, true)
	node.resource = resource
	resource.node = node
	node.load_values()
	node.position_offset = resource.graph_pos
	node.spawn_descendants()
	return node

func add_connection(from_node: StringName, from_port: int, to_node: StringName, to_port: int):
	print("Connected {0}'s {1} port to {2}'s {3} port.".format([from_node, from_port, to_node, to_port]))
	var connected : bool = is_node_connected(from_node, from_port, to_node, to_port)
	if !connected:
		var f_node : AudioNode = get_node(str(from_node))
		var t_node : AudioNode = get_node(str(to_node))
		#if !t_node is OutputNode:
			#t_node.resource.descendants[to_port] = f_node.resource
		connect_node(from_node, from_port, to_node, to_port)
		f_node.connected_to.append(t_node)
		match get_node_title(str(to_node)):
			"Output":
				output_connections.append(f_node)
				graph_resource.add_resource(f_node.resource, self)
				f_node.deleted.connect(func():
					output_connections.erase(f_node)
					graph_resource.graph.erase(f_node.resource), CONNECT_ONE_SHOT)
			_:
				#t_node.connected_by.append(f_node)
				f_node.deleted.connect(func():
					set_descendants(t_node.name), CONNECT_ONE_SHOT)
				f_node.resource.root_node = self
				set_descendants(to_node)

func set_descendants(node_name : String):
	var con_list : Array[Dictionary] = get_connection_list_from_node(node_name)
	var res_list : Array[PlayerResource]
	var node_list : Array[AudioNode]
	con_list.sort_custom(func(a,b):
		if a.to_port < b.to_port:
			return true
		return false)
	for i in con_list:
		if i.to_node != node_name:
			con_list.erase(i)
	for i in con_list:
		res_list.append(get_resource(i.from_node))
		node_list.append(get_node(str(i.from_node)))
	get_resource(node_name).descendants = res_list
	get_node(node_name).connected_by = node_list
	
func get_node_title(node_name : String) -> String:
	var node : AudioNode = get_node(node_name)
	return node.title

func get_resource(node_name : String) -> PlayerResource:
	var node : AudioNode = get_node(node_name)
	return node.resource

func spawn_node_menu(pos : Vector2):
	node_place_menu = node_place_menu_scene.instantiate()
	node_place_menu.graph = self
	add_child(node_place_menu)
	node_place_menu.position = pos

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	add_connection(from_node, from_port, to_node, to_port)

func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	print("Disconnected {0}'s {1} port from {2}'s {3} port.".format([from_node, from_port, to_node, to_port]))
	disconnect_node(from_node, from_port, to_node, to_port)
	var f_node : AudioNode = get_node(str(from_node))
	var t_node : AudioNode = get_node(str(to_node))
	
	f_node.connected_to.erase(t_node)
	match get_node_title(str(to_node)):
		"Output":
			output_connections.erase(f_node)
			graph_resource.graph.erase(f_node.resource)
		_:
			set_descendants(to_node)
			#t_node.connected_by.erase(f_node)
			#t_node.resource.descendants.erase(f_node.resource)
			if !(f_node in t_node.connected_by):
				f_node.deleted.disconnect(t_node._on_sound_deleted)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and node_place_menu:
				node_place_menu.queue_free()

func _on_delete_nodes_request(nodes: Array[StringName]) -> void:
	for node_name in nodes:
		if str(node_name) == "Output": continue
		var node : AudioNode = get_node(str(node_name))
		output_connections.erase(node)
		print("Deleted " + node.title + ".")
		node.emit_signal("deleted")
		node.queue_free()

func _on_popup_request(at_position: Vector2) -> void:
	spawn_node_menu(at_position)

func _on_connection_to_empty(from_node: StringName, from_port: int, release_position: Vector2) -> void:
	spawn_node_menu(release_position)
	
