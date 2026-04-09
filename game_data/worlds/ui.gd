## UI subsystem
class_name UI
extends CanvasLayer

@onready var died_screen: PanelContainer = $DiedScreen
@onready var hp_lab: Label = %HPLab
@onready var statsgrid: GridContainer = %Statsgrid

## Setup player death connection for death screen
func _ready() -> void:
	Global.ui = self
	Global.player_died.connect(show_died_screen)

func show_died_screen():
	#update stats on the screen
	paint_stats()
	died_screen.show()
	
func _on_retry_but_pressed() -> void:
	Global.reset_global()
	get_tree().reload_current_scene()

func set_hp_lab():
	hp_lab.text = "HP: " + str(Global.current_hp)

func paint_stats():
	var stats = Global.stats
	
	# Clear old data (not needed rn but maybe in the future)
	for i in range(statsgrid.get_child_count() - 1, 1, -1):
		statsgrid.get_child(i).queue_free()
	
	# templates copied and hidden
	var name_tpl = statsgrid.get_node("statname")
	var num_tpl = statsgrid.get_node("statnumber")
	name_tpl.hide()
	num_tpl.hide()
	
	# paint from the dict
	
	
	var count = 0
	for key in stats:
		#only showing 7 so as to not break ui
		if count >= 7:
			break
		# name
		var new_name = name_tpl.duplicate()
		new_name.text = str(key).capitalize()
		new_name.show()
		statsgrid.add_child(new_name)
		
		# number
		var new_num = num_tpl.duplicate()
		new_num.text = str(stats[key])
		new_num.show()
		statsgrid.add_child(new_num)
		
		count = count + 1
