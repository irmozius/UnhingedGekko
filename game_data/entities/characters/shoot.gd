class_name GekkoAttacks
extends Node

signal attack_finished

#hitbox hurtbox setup
@onready var hitbox: Hitbox = $"../Hitbox"
@onready var hurtbox: Hurtbox = $"../Hurtbox"
## Need reference for the shape of the hurtbox to enable/disable it.
@onready var hurtbox_shape: CollisionShape2D = $"../Hurtbox/CollisionShape2D"
@onready var attack_sprite: Sprite2D = $"../AttackSprite"
var projectile_sprite :Texture
var projectile_hframes: int = 3
## Hitmarker is just a debug visual currently used to show hits activating.
@onready var hit_marker: Sprite2D = $"../HitMarker"
@onready var attack_snd: GraphPlayer = $"../AttackSnd"

@export var projectile:PackedScene
@export var slash_cooldown_timer : float = 0.7
@export var slash_duration:float = 0.25
@export var slash_damage:float = 1.0
var slash_on_cooldown: bool = false #This disallows slash on cd
var current_weapon : WeaponResource:
	set(wep):
		current_weapon = wep
		attack_sprite.texture = wep.spritesheet
		Global.current_attack_damage = wep.damage
		Global.current_rank = wep.rank
		slash_duration = wep.attack_duration
		slash_cooldown_timer = wep.cooldown_duration
		hurtbox_shape.shape.radius = wep.hurtbox_radius
		attack_snd.graph = wep.sound
		if wep.projectile_spritesheet != null:
			projectile_sprite = wep.projectile_spritesheet
			projectile_hframes = wep.projectile_hframes

func slash():
	
	if not slash_on_cooldown:
		print("Player is Slasing")
		attack_snd.play()
		hurtbox_shape.disabled = false
		get_tree().create_timer(slash_duration).timeout.connect(attack_end, CONNECT_ONE_SHOT)
		fire_projectile()
		#cd stuff
		slash_on_cooldown = true
		get_tree().create_timer(slash_cooldown_timer).timeout.connect(func():
			slash_on_cooldown =false
			)
	else:
		print("Slash on cooldown")

func fire_projectile():
	if current_weapon.projectile_spritesheet != null and Global.current_hp == Global.max_hp:
		if projectile != null:
			var spawned_proj = projectile.instantiate()
			spawned_proj.projectile_sprite = projectile_sprite
			spawned_proj.damage = Global.current_attack_damage
			spawned_proj.global_position = $"..".global_position
			spawned_proj.projectile_hframes = projectile_hframes
			get_tree().current_scene.add_child(spawned_proj)

func attack_end():
	if Global.player_dead: return
	hurtbox_shape.disabled = true
	#hit_marker.hide()
	attack_finished.emit()
