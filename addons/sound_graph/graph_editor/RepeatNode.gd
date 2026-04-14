@tool
class_name RepeatNode extends AudioNode

@export var spinbox : SpinBox

func _ready() -> void:
	resource = Repeat.new()
	resource.node = self
	
func _on_spin_box_value_changed(value: float) -> void:
	resource.repetitions = value

func load_values():
	spinbox.value = resource.repetitions
