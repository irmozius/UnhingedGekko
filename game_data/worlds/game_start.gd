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
