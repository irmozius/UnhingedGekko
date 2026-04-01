class_name Hitbox
extends Area2D

signal received_hit

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var hurtbox : Hurtbox = area
		received_hit.emit(hurtbox)
