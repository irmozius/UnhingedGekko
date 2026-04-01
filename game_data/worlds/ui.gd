class_name UI
extends CanvasLayer

@onready var died_screen: PanelContainer = $DiedScreen

func _ready() -> void:
	Global.player_died.connect(show_died_screen)

func show_died_screen():
	died_screen.show()
	
func _on_retry_but_pressed() -> void:
	get_tree().reload_current_scene()
