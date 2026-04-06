## Playable character. Stays still to the left of the screen while the world moves.
## Has speed and jump force variables, and references to needed components.
## The FunctionalStateMachine is used to handle state transitions and executions.

class_name Gekko
extends CharacterBody2D

## State machine class.
var fsm = FunctionalStateMachineGDScript.new()

## The ground manager is used to simulate ground movement by moving the ground.
#@export var ground_manager : GroundManager
@export var speed : float = 3.5
@export var jump_force : float = 6

## Hitbox detects incoming hits, Hurtbox sends hits.
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var attack: GekkoAttacks = $attack

## Animation player
@onready var gekko_anim: AnimationPlayer = $GekkoAnim

## Bools for polling input.
var jump_requested : bool = false
var slash_requested : bool = false

## Used to enable/disable floor checking during jump.
var checking_floor : bool = false

#region Basic overrides


func _enter_tree() -> void:
	## Initialise global variables, so global knows
	## about the player and that it's not dead.
	Global.gekko = self
	Global.player_dead = false

func _ready() -> void:
	#Add the states to the state machine
	fsm.state_changed.connect(_on_state_change)
	fsm.add_state("Running", running_enter, running_exit, running_update, running_pupdate)
	fsm.add_state("InAir", inair_enter, inair_exit, inair_update, inair_pupdate)
	fsm.add_state("Attacking", attack_enter, attack_exit, attack_update, attack_pupdate)
	fsm.add_state("Dead", dead_enter, dead_exit, dead_update, Callable())
	fsm.add_state("Disabled", disabled_enter, disabled_exit, disabled_update, Callable())
	## Set initial state
	fsm.set_state("InAir")
	attack.current_weapon = WeaponDatabase.get_weapon_from_dbname("broadsword")
	
func _process(delta: float) -> void:
	## Let the state machine process the current state.
	fsm.update(delta)
	check_action_input()

func _physics_process(delta: float) -> void:
	## Physics process for current state.
	fsm.physics_update(delta)
	move_and_slide()

#endregion

#region SharedMethods

## Callback for state change.
func _on_state_change(s_name : String):
	print("Player state changed to " + s_name)
	
## Poll the state of input buttons.
func check_action_input():


	jump_requested = Input.is_action_just_pressed("jump")
	slash_requested = Input.is_action_just_pressed("slash")

## Mobile controls
var touch_start_pos = Vector2.ZERO
var swipe_threshold = 50 # Pixels needed to count as a swipe

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			touch_start_pos = event.position 
		else:
			# Check where they let go
			_check_for_swipe(event.position) 

func _check_for_swipe(end_pos: Vector2):
	var swipe_vector = end_pos - touch_start_pos
	if swipe_vector.length() > swipe_threshold:
		if swipe_vector.y < -abs(swipe_vector.x):
			jump_requested = true
			print("Swipe Jump!")
		if swipe_vector.x > abs(swipe_vector.y):
			slash_requested = true
			print("Swipe Slash!")

## Move the ground to simulate movement.
func scroll_ground(delta : float):
	#ground_manager.move(speed * delta)
	pass

## Initiate jump, adding vertical movement and changing state to InAir
func jump():
	velocity.y = -jump_force
	fsm.set_state("InAir")

## Initiate slash attack, enabling slash collision briefly
## then switching it back off. Also show hit marker.
func slash():
	if not attack.slash_on_cooldown:
		fsm.set_state("Attacking")

## When hitbox receives a hit, get the offender and call
## take_damage using its damage value.
func _on_hitbox_received_hit(att_hurtbox : Hurtbox) -> void:
	take_damage(att_hurtbox.damage)

## Remove the damage value from hp. Die if hp is 0.
func take_damage(amnt : int):
	Global.change_hp(-amnt)
	if Global.current_hp == 0:
		die()

## Add to current_hp.
func heal(amnt : int):
	Global.change_hp(amnt)

## Inform Global of death, and emit the global death signal. Finally, change to death state
## which has disabled input.
func die():
	Global.player_dead = true
	Global.player_died.emit()
	fsm.set_state("Dead")

## Callback used to handle the end of attacks. Signal comes from `attack`.
func _on_attack_finished():
	if is_on_floor():
		fsm.set_state("Running")
	else:
		fsm.set_state("InAir")
	
#endregion

### Functions below this point are to do with the different states of the state machine.

## Running state functions:
#region Running

## Entering running state
func running_enter():
	gekko_anim.play("running")

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

## Attacking state functions:
#region Attacking

## Entering attacking state
func attack_enter():
	gekko_anim.play("attack1")
	# safety check that fixes the bug where it tries to reattach to the same node
	if not attack.attack_finished.is_connected(_on_attack_finished):
		attack.attack_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)
## Exiting attacking state
func attack_exit():
	# safety line that cleans out the node. can be removed. 
	if attack.attack_finished.is_connected(_on_attack_finished):
		attack.attack_finished.disconnect(_on_attack_finished)

## Process attacking state:
func attack_update(_delta : float):
	pass

## attacking physics process: move the ground
func attack_pupdate(delta : float):
	scroll_ground(delta)

#endregion

## State for airborne movement. Pretty much just applies gravity and
## changes back to running once back on the ground.
#region InAir

func inair_enter():
	## 30 milisecond timer before enabling ground check.
	#timer is causing issues becuase attack makes the layer hang in the air
	#get_tree().create_timer(0.15).timeout.connect(func(): checking_floor = true, CONNECT_ONE_SHOT)
	pass
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
		if not attack.slash_on_cooldown:
			slash()
	if velocity.y >= 0 and is_on_floor():
		fsm.set_state("Running")
	#if checking_floor:
	#	if is_on_floor():
	#		## Leave InAir once on floor
	#		checking_floor = false
	#		fsm.set_state("Running")

#endregion

## Dead state. Does nothing.
#region Dead

func dead_enter():
	gekko_anim.play("death")
	velocity.y = 0

func dead_exit():
	pass

func dead_update(_delta : float):
	pass
	
#endregion

## Disabled state. Does nothing.
#region Disabled

func disabled_enter():
	pass

func disabled_exit():
	pass

func disabled_update(_delta : float):
	pass
	
#endregion
