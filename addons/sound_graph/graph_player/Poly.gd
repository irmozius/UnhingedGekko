@tool
class_name Poly extends PlayerResource

var count : int = 0

func execute():
	if node:
		node.pulse()
	if !descendants: return
	count = descendants.size()
	for i : PlayerResource in descendants:
		i.execute()
		i.finished.connect(descendant_callback, CONNECT_ONE_SHOT)

func descendant_callback():
	count -= 1
	if count == 0:
		finished.emit()

func get_type() -> String:
	return "Poly"
