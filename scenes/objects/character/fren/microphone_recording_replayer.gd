extends Node

@export var voice_stream_player : AudioStreamPlayer3D

var _recorded_audio_clips : Array[AudioStreamWAV]
var _recording_audio_clip_index : int = 0
var _time_recording : float = 0

var _playback_pause_timer : Timer

func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.audio_clip_index = _recording_audio_clip_index
	state.playback_position = _time_recording
	return state


func _load_state(state : Dictionary) -> void:
	# if voice_stream_player.stream != _recorded_audio_clips[state.audio_clip_index]:
	# 	voice_stream_player.stream = _recorded_audio_clips[state.audio_clip_index]
	# if voice_stream_player.get_playback_position() != state.playback_position:
	# 	voice_stream_player.seek(state.playback_position)
	
	if not voice_stream_player.playing:
		voice_stream_player.stream = _recorded_audio_clips[state.audio_clip_index]
		voice_stream_player.play(state.playback_position)

	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)

	pass


func _ready() -> void:
	ReplayManager.started_recording.connect(_on_replay_manager_started_recording)
	ReplayManager.stopped_recording.connect(_on_replay_manager_stopped_recording)

	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)


func _process(delta: float) -> void:
	if ReplayManager.is_recording():
		_time_recording += delta


func _on_playback_pause_timer_timeout() -> void:
	voice_stream_player.playing = false


func _on_replay_manager_started_recording() -> void:
	MicrophoneManager.start_recording()
	_time_recording = 0


func _on_replay_manager_stopped_recording() -> void:
	var audio_output : AudioStreamWAV = MicrophoneManager.stop_recording()
	_recorded_audio_clips.push_back(audio_output)
	_recording_audio_clip_index += 1
