extends Label

@onready var timer: Timer = $Timer

func _ready() -> void:
	text = str(Global.score)


func update_score():
	text = str(Global.score)

func toggle_score_pause(should_pause: bool, hide_score:bool = false):
	timer.paused = should_pause
	if should_pause and hide_score:
		modulate.a = 0 
	else:
		modulate.a = 1


func _on_timer_timeout() -> void:
	Global.score += 1
	update_score()

func pop_score():
	pivot_offset = self.size / 2
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.7, 1.7), 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
