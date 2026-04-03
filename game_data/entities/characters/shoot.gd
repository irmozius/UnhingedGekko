class_name GekkoAttacks
extends Node

signal attack_finished

#hitbox hurtbox setup
@onready var hitbox: Hitbox = $"../Hitbox"
@onready var hurtbox: Hurtbox = $"../Hurtbox"
## Need reference for the shape of the hurtbox to enable/disable it.
@onready var hurtbox_shape: CollisionShape2D = $"../Hurtbox/CollisionShape2D"
@onready var attack_sprite: Sprite2D = $"../AttackSprite"

## Hitmarker is just a debug visual currently used to show hits activating.
@onready var hit_marker: Sprite2D = $"../HitMarker"
 

@export var slash_cooldown_timer : float = 0.7
@export var slash_duration:float = 0.25
@export var slash_damage:float = 1.0
var slash_on_cooldown: bool = false #This disallows slash on cd
var current_weapon : WeaponResource:
	set(wep):
		current_weapon = wep
		attack_sprite.texture = wep.spritesheet
		Global.current_attack_damage = wep.damage
		slash_duration = wep.attack_duration
		slash_cooldown_timer = wep.cooldown_duration
		hurtbox_shape.shape.radius = wep.hurtbox_radius

func slash():
	
	if not slash_on_cooldown:
		print("Player is Slasing")
		hurtbox_shape.disabled = false
		#hit_marker.show()
		get_tree().create_timer(slash_duration).timeout.connect(attack_end, CONNECT_ONE_SHOT)
			
		#cd stuff
		slash_on_cooldown = true
		get_tree().create_timer(slash_cooldown_timer).timeout.connect(func():
			slash_on_cooldown =false
			)
	else:
		print("Slash on cooldown")

func attack_end():
	if Global.player_dead: return
	hurtbox_shape.disabled = true
	#hit_marker.hide()
	attack_finished.emit()
