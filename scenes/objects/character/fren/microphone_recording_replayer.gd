extends Node

@export var voice_stream_player : AudioStreamPlayer3D


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	return state


func _load_state(state : Dictionary) -> void:
	pass


func _ready() -> void:
	ReplayManager.started_recording.connect(_on_replay_manager_started_recording)
	ReplayManager.stopped_recording.connect(_on_replay_manager_stopped_recording)


func _on_replay_manager_started_recording() -> void:
	MicrophoneManager.start_recording()


func _on_replay_manager_stopped_recording() -> void:
	var audio_output : AudioStreamWAV = MicrophoneManager.stop_recording()
	voice_stream_player.stream = audio_output
	voice_stream_player.play()
