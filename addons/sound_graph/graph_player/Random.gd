@tool
class_name Random extends PlayerResource

func execute():
	if node:
		node.pulse()
	if !descendants: return
	var choice : PlayerResource = descendants.pick_random()
	choice.execute()
	choice.finished.connect(func(): finished.emit(), CONNECT_ONE_SHOT)

func get_type() -> String:
	return "Random"
