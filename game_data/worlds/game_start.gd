extends Node2D

@export var level_1 : PackedScene

@onready var play_but: TextureButton = $CanvasLayer/PlayBut
@onready var gek_anim: AnimationPlayer = $GekAnim
@onready var cam_anim: AnimationPlayer = $CamAnim


func _on_play_but_pressed() -> void:
	play_but.hide()
	cam_anim.play("move_cam")
	gek_anim.play("wake")
	await cam_anim.animation_finished
	get_tree().change_scene_to_packed(level_1)


func _on_music_toggle_toggled(toggled_on: bool) -> void:
	print("clicked")
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus, not toggled_on)
