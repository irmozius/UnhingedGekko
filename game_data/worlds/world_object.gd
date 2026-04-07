extends Sprite2D

@export var textures: Array[Texture2D] = []

# Set this to match your speed_layer_1 or whichever layer it belongs to!
@export var scroll_speed: float = 100.0 

func _ready() -> void:
	randomize_texture()

func _process(delta: float) -> void:
	# Manually move the sprite to the left
	position.x -= scroll_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var screen_width = get_viewport_rect().size.x
	position.x += screen_width + (texture.get_size().x+200 if texture else 400.0)
	randomize_texture()

func randomize_texture() -> void:
	if textures.is_empty():
		return
		
	texture = textures.pick_random()
	
	# Keep the bottom edge aligned
	offset.y = -(texture.get_size().y / 2.0)
