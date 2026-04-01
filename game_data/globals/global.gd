extends Node

## Global references for player and motion
var gekko : Gekko
var current_movement_speed : float = 0.0
var player_dead : bool = false

signal player_died
