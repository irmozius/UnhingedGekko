## Basic Area extension to filter only for incoming hits.
class_name Hitbox
extends Area2D

signal received_hit

## Ensure that the hit is from a Hurtbox, then emit a signal.
func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var hurtbox : Hurtbox = area
		received_hit.emit(hurtbox)
