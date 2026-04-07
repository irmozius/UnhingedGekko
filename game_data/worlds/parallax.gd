class_name ParallaxBG
extends Node2D

@export var speed_layer_1: Vector2 = Vector2(-150, 0) # Fastest (Closest layer)
@export var speed_layer_2: Vector2 = Vector2(-100, 0) # Medium speed
@export var speed_layer_3: Vector2 = Vector2(-50, 0)  # Slowest (Furthest layer)

func _ready() -> void:
	Global.parallax = self
	paint_star_speed()
	Global.player_died.connect(_on_player_died)

func _on_player_died() -> void:
	# Stop the background instantly when the signal fires
	slow_background(0)

func paint_star_speed():
	$Parallax2D.autoscroll = speed_layer_1
	$Parallax2D2.autoscroll = speed_layer_2
	$Parallax2D3.autoscroll = speed_layer_3

# SLOWING FOR BOSS FIGHTS OR SOMETHING
func slow_background(amount:float = 3):
	if amount == 0:
		speed_layer_1 =Vector2.ZERO
		speed_layer_2 =Vector2.ZERO
		speed_layer_3 =Vector2.ZERO
	else:	
		speed_layer_1 /=  amount
		speed_layer_2 /= amount
		speed_layer_3 /= amount
	paint_star_speed()


func reset_background():
	speed_layer_1 =  Vector2(-150, 0)
	speed_layer_2 = Vector2(-100, 0)
	speed_layer_3 = Vector2(-50, 0)
	paint_star_speed()
