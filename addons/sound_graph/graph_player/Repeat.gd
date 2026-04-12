@tool
class_name Repeat extends PlayerResource


@export var repetitions : int = 1

func execute():
	var child : PlayerResource = descendants[0]
	for i : int in range(repetitions):
		if node:
			node.pulse()
		child.execute()
		await child.finished
	finished.emit()

func get_type() -> String:
	return "Repeat"
