extends AudioStreamPlayer3D

var _cached_audio_clips : Array[AudioStream]
var _playback_pause_timer : Timer


func _ready() -> void:
	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)


func _on_playback_pause_timer_timeout() -> void:
	playing = false


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = position
	state.playing = playing
	state.volume_db = volume_db
	if playing:
		state.audio_clip_index = _get_cached_audio_clip_index(stream)
		state.playback_position = get_playback_position()
		# print("%s: saving playback pos = %f" % [self, state.playback_position])
	else:
		state.audio_clip_index = -1
		state.playback_position = 0
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	volume_db = state.volume_db
	if not state.playing:
		playing = false

	if state.playing and not playing and state.audio_clip_index >= 0:
		# print("%s: playing! position: %f" % [self, state.playback_position])
		stream = _cached_audio_clips[state.audio_clip_index]
		play(state.playback_position)

	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)


func _get_cached_audio_clip_index(audio_stream : AudioStream) -> int:
	var i = 0
	for clip in _cached_audio_clips:
		if clip == audio_stream:
			break
		i += 1
	
	if i >= len(_cached_audio_clips):
		_cached_audio_clips.append(audio_stream)
		# print("%s adding new clip at index %d" % [self, i])
	
	return i
