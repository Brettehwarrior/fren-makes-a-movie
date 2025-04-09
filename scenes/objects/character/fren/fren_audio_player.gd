extends Node3D

@export var footstep_stream : AudioStream

func play_footstep_sound() -> void:
	if ReplayManager.is_playing_back():
		return
	AudioManager.play_oneshot(footstep_stream, global_position, -24)
