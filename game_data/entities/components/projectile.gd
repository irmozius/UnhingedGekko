extends Node2D

@export var speed: float = 50.0
@export var lifetime: float = 1.0 # Seconds before the projectile disappears
var damage: float = 1.0
var projectile_sprite: Texture
var projectile_hframes: int = 3
@onready var hurtbox = $Hurtbox
@onready var sprite = $Projectile

func _ready() -> void:

	hurtbox.damage = damage
	if projectile_sprite != null:
		sprite.texture = projectile_sprite
		sprite.hframes = projectile_hframes
	get_tree().create_timer(lifetime).timeout.connect(func(): queue_free())

func _process(delta: float) -> void:
	position.x += speed * delta
