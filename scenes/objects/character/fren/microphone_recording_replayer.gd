extends Node

@export var voice_stream_player : AudioStreamPlayer3D

var _recorded_audio_clips : Array[AudioStreamWAV]
var _recording_audio_clip_index : int = 0
var _time_recording : float = 0

func _ready() -> void:
	ReplayManager.started_recording.connect(_on_replay_manager_started_recording)
	ReplayManager.stopped_recording.connect(_on_replay_manager_stopped_recording)


func _process(delta: float) -> void:
	if ReplayManager.is_recording():
		_time_recording += delta


func _on_replay_manager_started_recording() -> void:
	MicrophoneManager.start_recording()
	_time_recording = 0


func _on_replay_manager_stopped_recording() -> void:
	var audio_output : AudioStreamWAV = MicrophoneManager.stop_recording()
	_recorded_audio_clips.push_back(audio_output)
	_recording_audio_clip_index += 1
