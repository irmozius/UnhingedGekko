@tool
class_name GraphPanel
extends PanelContainer

@onready var graph : Graph = $%Graph
@onready var save_dialog : FileDialog = $%SaveDialog
@onready var load_dialog : FileDialog = $%LoadDialog

func _on_save_pressed() -> void:
	save_dialog.show()
	
func _on_play_pressed() -> void:
	graph.play_graph()

func _on_clear_pressed() -> void:
	graph.clear_graph()

func _on_load_pressed() -> void:
	load_dialog.show()

func _on_save_dialog_file_selected(path: String) -> void:
	var graph_res : SoundGraph = graph.graph_resource
	graph_res.output_position = graph.output_node.position_offset
	graph_res.take_over_path(path)
	print("saving:\n" + str(graph_res.graph))
	ResourceSaver.save(graph_res, path)

func _on_load_dialog_file_selected(path: String) -> void:
	var graph_res : SoundGraph = ResourceLoader.load(path, "SoundGraph")
	print("loading:\n" + str(graph_res.graph))
	graph.load_graph(graph_res)
