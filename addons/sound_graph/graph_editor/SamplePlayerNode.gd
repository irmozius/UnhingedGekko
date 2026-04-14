@tool
class_name SamplePlayerNode extends AudioNode

@export var add_button : Button
@export var file_dialog : FileDialog
@export var play_button : Button
@export var pitch_min_input : SpinBox
@export var pitch_max_input : SpinBox
@export var vol_min_input : SpinBox
@export var vol_max_input : SpinBox
@export var sample_label : Label
@export var pitch_menu : HBoxContainer
@export var vol_menu : HBoxContainer

var samples : Array[AudioStream] = []

func _ready() -> void:
	resource = SamplePlayer.new()
	resource.node = self
	resource.root_node = get_parent()

func load_values():
	samples = resource.samples
	set_label_text()
	pitch_min_input.value = resource.pitch_min
	pitch_max_input.value = resource.pitch_max
	vol_min_input.value = resource.vol_min
	vol_max_input.value = resource.vol_max

func set_label_text():
	sample_label.text = ""
	var count : int = samples.size()
	var index : int = 0
	for sample : AudioStream in samples:
		var text : String = sample.resource_path.trim_prefix("res://")
		index += 1
		sample_label.text += text
		if index != count:
			sample_label.text += "\n" 

func _on_choose_sample_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	var sample : AudioStream = load(path)
	resource.samples.append(sample)
	samples = resource.samples
	var trimmed_path : String = path.trim_prefix("res://")
	print("SamplePlayer loaded '" + trimmed_path + "'.")
	set_label_text()

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

func _on_remove_pressed() -> void:
	var last_sample : AudioStream = resource.samples[-1]
	resource.samples.erase(last_sample)
	samples = resource.samples
	set_label_text()

func _on_toggle_ran_opt_toggled(toggled_on: bool) -> void:
	pitch_menu.visible = toggled_on
	vol_menu.visible = toggled_on
	if !toggled_on:
		pitch_min_input.value = 1.0
		pitch_max_input.value = 1.0
		vol_min_input.value = 0.0
		vol_max_input.value = 0.0
	else:
		pitch_min_input.value = 0.95
		pitch_max_input.value = 1.05
		vol_min_input.value = -9.0
		vol_max_input.value = 0.0
	resource.pitch_min = pitch_min_input.value
	resource.pitch_min = pitch_max_input.value
	resource.vol_min = vol_min_input.value
	resource.vol_max = vol_max_input.value
	
