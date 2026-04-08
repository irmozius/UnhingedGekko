class_name WeaponResource
extends Resource

@export_category("Details")
@export var name : String = "Cool Weapon"
@export var db_key : String = "cool_weapon"
@export_multiline() var description : String = "This weapon comes from the depths of time.\nNone remain who know its true origin."
@export_enum("Normal", "Rare", "Unhinged") var rank : int = 0

@export_category("Stats")
@export var damage : int = 1
@export var attack_duration : float = 0.1
@export var cooldown_duration : float = 0.3
@export var hurtbox_radius : float = 15

@export_category("Art")
@export var spritesheet : Texture2D
@export var projectile_spritesheet : Texture2D
@export var projectile_hframes : int = 3
@export var icon : Texture2D
@export var sound : AudioStream

var equipped : bool
