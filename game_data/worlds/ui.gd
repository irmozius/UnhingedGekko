## UI subsystem
class_name UI
extends CanvasLayer

@onready var died_screen: PanelContainer = $DiedScreen
@onready var hp_lab: Label = %HPLab
@onready var hp_bar: HBoxContainer = %HPbar
@onready var statsgrid: GridContainer = %Statsgrid

## Setup player death connection for death screen
func _ready() -> void:
	set_hp_bar()
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

func set_hp_bar():
	# Use template to populate
	var template_heart = hp_bar.get_child(0)
	template_heart.hide()
	
	
	var living_hearts = []
	for i in range(1, hp_bar.get_child_count()):
		var heart = hp_bar.get_child(i)
		# Ignore hearts that are already dying or queued for deletion
		if not heart.has_meta("dying") and not heart.is_queued_for_deletion():
			living_hearts.append(heart)
			
	var current_count = living_hearts.size()
	var target_hp = Global.current_hp
	
	# add hearts
	if current_count < target_hp:
		for i in range(target_hp - current_count):
			var new_heart = template_heart.duplicate()
			new_heart.show()
			hp_bar.add_child(new_heart)
			#since this is a sprite it does not obey hbox 
			new_heart.position.x = template_heart.position.x + ((current_count + i) * 11) 
			
	# take damage
	elif current_count > target_hp:
		var damage_taken = current_count - target_hp
		for i in range(damage_taken):
			var heart_to_lose = living_hearts[living_hearts.size() - 1 - i]
			# Tag, so we don't accidentally count it again
			heart_to_lose.set_meta("dying", true)
			# Play the animation
			heart_to_lose.play("default")
			
			# Delete it automatically when the animation finishes
			if not heart_to_lose.animation_finished.is_connected(heart_to_lose.queue_free):
				heart_to_lose.animation_finished.connect(heart_to_lose.queue_free)


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
