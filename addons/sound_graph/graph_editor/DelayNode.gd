@tool
class_name DelayNode extends AudioNode

@export var timer : Timer
@export var spinbox : SpinBox

func _ready() -> void:
	resource = Delay.new()
	resource.node = self

	
func _on_spin_box_value_changed(value: float) -> void:
	resource.delay_time = value

func load_values():
	spinbox.value = resource.delay_time
