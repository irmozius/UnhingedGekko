@tool
class_name NodePlaceMenu extends VBoxContainer

@export var node_list : Array[PackedScene]

var graph : Graph

func _ready() -> void:
	var index : int = 0
	for button : Button in get_children():
		button.pressed.connect(_on_button_pressed.bind(node_list[index]))
		index += 1

func _on_button_pressed(node : PackedScene):
	var new_node : GraphNode = node.instantiate()
	var pos : Vector2 = (position + graph.scroll_offset) / graph.zoom
	graph.add_child(new_node, true)
	print("Placed " + new_node.title + ".")
	new_node.position_offset = pos
	graph.node_place_menu = null
	queue_free()
