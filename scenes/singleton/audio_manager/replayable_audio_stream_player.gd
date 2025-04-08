extends AudioStreamPlayer3D

var _cached_audio_clips : Array[AudioStream]
var _cached_audio_clip_index : int
var _playback_pause_timer : Timer


func _ready() -> void:
	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)


func _on_playback_pause_timer_timeout() -> void:
	playing = false


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.audio_clip_index = _cached_audio_clip_index
	state.playback_position = get_playback_position()
	return state


func _load_state(state : Dictionary) -> void:
	if not playing:
		stream = _cached_audio_clips[state.audio_clip_index]
		play(state.playback_position)

	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)

	pass


func _get_cached_audio_clip_index(audio_sample : AudioStream) -> int:
	var i = 0
	for clip in _cached_audio_clips:
		if clip == audio_sample:
			break
		i += 1
	
	if i >= len(_cached_audio_clips):
		_cached_audio_clips.append(audio_sample)
		print("%s adding new clip at index %d" % [self, i])
	
	return i
