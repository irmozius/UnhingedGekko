@tool
class_name Sequence extends PlayerResource

func execute():
	if !descendants: return
	var index := 0
	var size := descendants.size()
	for res : PlayerResource in descendants:
		if node:
			node.pulse()
		res.execute()
		if index <= size:
			index += 1
			await res.finished
	finished.emit()

func get_type() -> String:
	return "Sequence"
