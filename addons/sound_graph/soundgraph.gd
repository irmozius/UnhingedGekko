@tool
extends EditorPlugin

const graph_scene : PackedScene = preload("uid://b4ddylxcesvgx")

# var graph_dock : EditorDock
var graph_screen : PanelContainer

func _enable_plugin() -> void:
	# Add autoloads here.
	print('SoundGraph enabled.')


func _disable_plugin() -> void:
	# Remove autoloads here.
	print('SoundGraph disabled.')


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	graph_screen = graph_scene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(graph_screen)
	_make_visible(false)
	# var graph_scene : Graph = preload("uid://cujej7aecjsk4").instantiate()
	# graph_dock = EditorDock.new()
	# graph_dock.add_child(graph_scene)
	# graph_dock.title = "SoundGraph"
	# graph_dock.default_slot = EditorDock.DOCK_SLOT_BOTTOM
	# graph_dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
	# add_dock(graph_dock)

func _exit_tree() -> void:
	if graph_screen:
		graph_screen.queue_free()
	# Clean-up of the plugin goes here.
	# remove_dock(graph_dock)
	# graph_dock.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	if graph_screen:
		graph_screen.visible = visible

func _get_plugin_name():
	return "SoundGraph"

func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("GraphEdit", "EditorIcons")
