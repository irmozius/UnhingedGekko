@tool
class_name GraphPlayer extends Node

@export_tool_button("Test Sound", "AudioStreamPlayer") var test_button : Callable = play

@export var root_node : Node:
	set(n):
		root_node = n
		set_graph_root_node()

@export var graph : SoundGraph:
	set(g):
		graph = g
		set_graph_root_node()

func play():
	for res : PlayerResource in graph.graph:
		res.execute()

func set_graph_root_node():
	for res : PlayerResource in graph.graph:
		res.root_node = root_node
