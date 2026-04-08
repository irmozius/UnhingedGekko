class_name Chest
extends Node2D

@export var highlight_colours : Array[Color]
@export var icons : Array[TextureRect]
@onready var highlights: Sprite2D = $Highlights
@onready var hitbox: Hitbox = $Hitbox
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var ui: CanvasLayer = $UI
@onready var textbox: PanelContainer = $UI/textbox
@onready var title: Label = %Title
@onready var description: Label = %Desc

var moving : bool = true
var weapons : Array[WeaponResource]
var hovered_weapon : WeaponResource

func _ready() -> void:
	var highest_rank : int
	for i : int in range(3):
		var new_wep : WeaponResource = WeaponDatabase.get_random_weapon()
		weapons.append(new_wep)
		icons[i].texture = new_wep.icon
		icons[i].mouse_entered.connect(icon_hovered.bind(new_wep, icons[i]))
		icons[i].mouse_exited.connect(icon_exited.bind(icons[i]))
		icons[i].gui_input.connect(icon_input)
		highest_rank = max(highest_rank, new_wep.rank)
	highlights.modulate = highlight_colours[highest_rank]
	
func _physics_process(delta: float) -> void:
	if moving:
		position.x -= 150 * delta

func open_chest():
	ui.show()

func icon_hovered(wep : WeaponResource, but : TextureRect):
	
	hovered_weapon = wep
	title.text = wep.name
	
	description.text = wep.description
	textbox.show()
	but.pivot_offset = but.size / 2
	but.scale = but.scale *1.2
	but.modulate = Color.WHITE * 1.6
	
func icon_exited(but : TextureRect):
	hovered_weapon = null
	#textbox.hide()
	but.pivot_offset = but.size / 2
	but.scale = Vector2(1.0,1.0)
	but.modulate = Color.WHITE

func icon_input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_released():
			get_weapon()

func get_weapon():
	Global.gekko.attack.current_weapon = hovered_weapon
	Global.resume()
	queue_free()

func _on_hitbox_received_hit(_hurtbox : Hurtbox) -> void:
	hitbox.queue_free()
	anim.play("destroy")
	moving = false
	Global.halt()
	open_chest()
