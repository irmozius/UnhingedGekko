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
		set_graph_bus()

@export var bus_name : String = "":
	set(nm):
		bus_name = nm
		set_graph_bus()

func play():
	if !graph: return
	for res : PlayerResource in graph.graph:
		res.execute()

func set_graph_root_node():
	if !graph: return
	for res : PlayerResource in graph.graph:
		res.root_node = root_node

func set_graph_bus():
	if !graph: return
	for res : PlayerResource in graph.graph:
		res.audio_bus = bus_name
