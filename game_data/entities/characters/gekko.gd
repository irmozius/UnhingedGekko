class_name Gekko
extends CharacterBody2D

var fsm = FunctionalStateMachineGDScript.new()

@export var ground_manager : GroundManager
@export var speed : float = 3.5
@export var jump_force : float = 6
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D

var jump_requested : bool = false
var slash_requested : bool = false
var checking_floor : bool = false

#region Basic overrides

func _enter_tree() -> void:
	Global.gekko = self

func _ready() -> void:
	#Add the states to the state machine
	fsm.state_changed.connect(on_state_change)
	fsm.add_state("Running", running_enter, running_exit, running_update, running_pupdate)
	fsm.add_state("InAir", inair_enter, inair_exit, inair_update, inair_pupdate)
	fsm.set_state("InAir")
	
func _process(delta: float) -> void:
	fsm.update(delta)
	check_action_input()

func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)
	move_and_slide()

func on_state_change(s_name : String):
	print("Player state changed to " + s_name)

func scroll_ground(delta : float):
	ground_manager.move(speed * delta)

#endregion

#region SharedMethods

func check_action_input():
	jump_requested = Input.is_action_just_pressed("jump")
	slash_requested = Input.is_action_just_pressed("slash")

func jump():
	velocity.y = -jump_force
	fsm.set_state("InAir")

func slash():
	hurtbox_shape.disabled = false
	get_tree().create_timer(0.5).timeout.connect(func(): hurtbox_shape.disabled = true, CONNECT_ONE_SHOT)

func _on_hitbox_received_hit(hurtbox : Hurtbox) -> void:
	print('ouch!')

#region Running

func running_enter():
	pass

func running_exit():
	pass
	
func running_update(_delta : float):
	if Input.is_action_just_pressed("jump"):
		jump()
		return
	elif slash_requested:
		slash()
	
func running_pupdate(delta : float):
	scroll_ground(delta)

#endregion

#region InAir

func inair_enter():
	get_tree().create_timer(0.3).timeout.connect(func(): checking_floor = true, CONNECT_ONE_SHOT)

func inair_exit():
	velocity.y = 0

func inair_update(_delta : float):
	pass
	
func inair_pupdate(delta : float):
	velocity.y += 700 * delta
	scroll_ground(delta)
	if checking_floor:
		if is_on_floor():
			checking_floor = false
			fsm.set_state("Running")

#endregion
