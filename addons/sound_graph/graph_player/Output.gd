@tool
class_name Output extends PlayerResource

func execute():
	pass

func get_type() -> String:
	return "Output"

func return_copy():
	return Output.new()
