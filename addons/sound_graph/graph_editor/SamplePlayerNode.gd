@tool
class_name SamplePlayerNode extends AudioNode

@export var sample_button : Button
@export var file_dialog : FileDialog
@export var play_button : Button
@export var pitch_min_input : SpinBox
@export var pitch_max_input : SpinBox
@export var vol_min_input : SpinBox
@export var vol_max_input : SpinBox

var sample : AudioStream = null

func _ready() -> void:
	resource = SamplePlayer.new()
	resource.node = self
	resource.root_node = get_parent()

func load_values():
	sample_button.text = resource.sample.resource_path.trim_prefix("res://")
	pitch_min_input.value = resource.pitch_min
	pitch_max_input.value = resource.pitch_max
	vol_min_input.value = resource.vol_min
	vol_max_input.value = resource.vol_max

func _on_choose_sample_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	resource.sample = load(path)
	var trimmed_path : String = path.trim_prefix("res://")
	print("SamplePlayer loaded '" + trimmed_path + "'.")
	sample_button.text = trimmed_path

func _on_play_pressed() -> void:
	resource.execute()

func _on_pitch_from_value_changed(value: float) -> void:
	resource.pitch_min = value

func _on_pitch_to_value_changed(value: float) -> void:
	resource.pitch_max = value

func _on_vol_from_value_changed(value: float) -> void:
	resource.vol_min = value

func _on_vol_to_value_changed(value: float) -> void:
	resource.vol_max = value
