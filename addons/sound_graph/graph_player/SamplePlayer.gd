@tool
class_name SamplePlayer extends PlayerResource

@export var samples : Array[AudioStream] = []
@export var pitch_min : float = 1.0
@export var pitch_max : float = 1.0
@export var vol_min : float = 0.0
@export var vol_max : float = 0.0

func play_sound() -> void:
	if samples.size() == 0: return
	var sample : AudioStream = samples.pick_random()
	print("Playing '", sample.resource_path.trim_prefix("res://"), "'.")
	var player : AudioStreamPlayer = AudioStreamPlayer.new()
	root_node.add_child(player)
	player.stream = sample
	player.bus = audio_bus
	player.finished.connect(func():
		player.queue_free()
		finished.emit(), CONNECT_ONE_SHOT)
	_set_pitch_and_volume(player)
	player.play()

func _set_pitch_and_volume(player : AudioStreamPlayer):
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.volume_db = randf_range(vol_min, vol_max)

func execute():
	if node:
		node.pulse()
	play_sound()

func get_type() -> String:
	return "SamplePlayer"
