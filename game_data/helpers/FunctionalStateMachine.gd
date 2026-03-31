class_name FunctionalStateMachineGDScript
extends Node

# A simple functional state machine implementation. Each state is represented by a string name,
# and has an associated enter, exit, update, and physics update function. The state machine will
# call the appropriate functions when transitioning between states, but the update and physics
# update functions will need to be called from the owning node's _Process and _PhysicsProcess functions.

signal state_changed(new_state_name: String)

var states : Dictionary[String, State] = {}
var current_state_name : String = ""
var current_state : State = null
var current_update_func : Callable
var current_physics_update_func : Callable

# Define a state class to hold the enter, exit, update, and physics update functions for each state.
# Physics update is optional, so it can be null if the state doesn't need it.

class State:
	var on_enter: Callable
	var on_exit: Callable
	var on_update: Callable
	var on_physics_update: Callable
	func _init(enter: Callable, exit: Callable, update: Callable, physics_update: Callable) -> void:
		assert(enter.is_valid(), "Enter function must be a valid callable")
		assert(exit.is_valid(), "Exit function must be a valid callable")
		assert(update.is_valid(), "Update function must be a valid callable")
		self.on_enter = enter
		self.on_exit = exit
		self.on_update = update
		self.on_physics_update = physics_update

## Run the update function for the current state. This should be called from the owning node's _process function.
func update(delta: float) -> void:
	if current_update_func.is_valid():
		current_update_func.call(delta)

## Run the physics update function for the current state. This should be called from the owning node's _physics_process function.
func physics_update(delta: float) -> void:
	if current_physics_update_func.is_valid():
		current_physics_update_func.call(delta)

## Add a new state to the state machine. The state name must be unique, and the enter, exit,
## and update functions must be valid callables. The physics update function is optional.
func add_state(new_state_name: String, enter_func: Callable, exit_func: Callable, update_func: Callable, physics_update_func: Callable) -> void:
	assert(!states.has(new_state_name), "State with name '%s' already exists" % new_state_name)
	states[new_state_name] = State.new(enter_func, exit_func, update_func, physics_update_func)

## Change the current state to the specified state name. This will call the exit function of
## the current state (if any), and the enter function of the new state.
func set_state(new_state_name: String) -> void:
	assert(states.has(new_state_name), "State with name '%s' does not exist" % new_state_name)
	if current_state != null and current_state.on_exit.is_valid():
		current_state.on_exit.call()
	current_state_name = new_state_name
	current_state = states[new_state_name]
	current_update_func = current_state.on_update
	current_physics_update_func = current_state.on_physics_update
	current_state.on_enter.call()
	state_changed.emit(current_state_name)
