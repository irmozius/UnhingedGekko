## Playable character. Stays still to the left of the screen while the world moves.
## Has speed and jump force variables, and references to needed components.
## The FunctionalStateMachine is used to handle state transitions and executions.

class_name Gekko
extends CharacterBody2D

## State machine class.
var fsm = FunctionalStateMachineGDScript.new()

## The ground manager is used to simulate ground movement by moving the ground.
@export var ground_manager : GroundManager
@export var speed : float = 3.5
@export var jump_force : float = 6

## Hitbox detects incoming hits, Hurtbox sends hits.
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox

## Need reference for the shape of the hurtbox to enable/disable it.
@onready var hurtbox_shape: CollisionShape2D = $Hurtbox/CollisionShape2D

## Hitmarker is just a debug visual currently used to show hits activating.
@onready var hit_marker: Sprite2D = $HitMarker

## Bools for polling input.
var jump_requested : bool = false
var slash_requested : bool = false

## Used to enable/disable floor checking during jump.
var checking_floor : bool = false

## Slash controls
@export_group("Slash Settings")
@export var slash_cooldown_timer : float = 0.7
@export var slash_duration:float = 0.5
var slash_on_cooldown: bool = false #This disallows slash on cd



#region Basic overrides


func _enter_tree() -> void:
	## Initialise global variables, so global knows
	## about the player and that it's not dead.
	Global.gekko = self
	Global.player_dead = false

func _ready() -> void:
	#Add the states to the state machine
	fsm.state_changed.connect(on_state_change)
	fsm.add_state("Running", running_enter, running_exit, running_update, running_pupdate)
	fsm.add_state("InAir", inair_enter, inair_exit, inair_update, inair_pupdate)
	fsm.add_state("Dead", dead_enter, dead_exit, dead_update, Callable())
	## Set initial state
	fsm.set_state("InAir")
	
func _process(delta: float) -> void:
	## Let the state machine process the current state.
	fsm.update(delta)
	check_action_input()

func _physics_process(delta: float) -> void:
	## Physics process for current state.
	fsm.physics_update(delta)
	move_and_slide()

## Callback for state change.
func on_state_change(s_name : String):
	print("Player state changed to " + s_name)

## Move the ground to simulate movement.
func scroll_ground(delta : float):
	ground_manager.move(speed * delta)

#endregion

#region SharedMethods

## Poll the state of input buttons.
func check_action_input():
	jump_requested = Input.is_action_just_pressed("jump")
	slash_requested = Input.is_action_just_pressed("slash")

## Initiate jump, adding vertical movement and changing state to InAir
func jump():
	velocity.y = -jump_force
	fsm.set_state("InAir")

## Initiate slash attack, enabling slash collision briefly
## then switching it back off. Also show hit marker.
func slash():
	
	if not slash_on_cooldown:
		print("Player is Slasing")
		hurtbox_shape.disabled = false
		hit_marker.show()
		get_tree().create_timer(slash_duration).timeout.connect(func():
			hurtbox_shape.disabled = true
			hit_marker.hide(),
			CONNECT_ONE_SHOT)
			
		#cd stuff
		slash_on_cooldown = true
		get_tree().create_timer(slash_cooldown_timer).timeout.connect(func():
			slash_on_cooldown =false
			)
	else:
		print("Slash on cooldown")

## When hitbox receives a hit, die. Pass through the hurtbox in case we need its data later.
func _on_hitbox_received_hit(_hurtbox : Hurtbox) -> void:
	die()

## Inform Global of death, and emit the global death signal. Finally, change to death state
## which has disabled input.
func die():
	Global.player_dead = true
	Global.player_died.emit()
	fsm.set_state("Dead")
	
#endregion

### Functions below this point are to do with the different states of the state machine.

## Running state functions:
#region Running

## Entering running state
func running_enter():
	pass

## Exiting running state
func running_exit():
	pass

## Process running state: jump or slash if the buttons are pressed
func running_update(_delta : float):
	if jump_requested:
		jump()
		return
	elif slash_requested:
		slash()

## Running physics process: move the ground
func running_pupdate(delta : float):
	scroll_ground(delta)

#endregion

## State for airborne movement. Pretty much just applies gravity and
## changes back to running once back on the ground.
#region InAir

func inair_enter():
	## 30 milisecond timer before enabling ground check.
	get_tree().create_timer(0.3).timeout.connect(func(): checking_floor = true, CONNECT_ONE_SHOT)

## Reset vertical velocity on exit.
func inair_exit():
	velocity.y = 0

func inair_update(_delta : float):
	pass
	
func inair_pupdate(delta : float):
	## Apply gravity and continue moving the ground
	velocity.y += 900 * delta
	scroll_ground(delta)
	##allow slashing mid air
	if slash_requested:
		slash()
	if checking_floor:
		if is_on_floor():
			## Leave InAir once on floor
			checking_floor = false
			fsm.set_state("Running")

#endregion

## Dead state. Does nothing.
#region Dead

func dead_enter():
	velocity.y = 0

func dead_exit():
	pass

func dead_update(_delta : float):
	pass
	
#endregion
