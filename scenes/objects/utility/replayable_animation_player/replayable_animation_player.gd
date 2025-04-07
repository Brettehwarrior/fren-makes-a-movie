class_name ReplayableAnimationPlayer
extends AnimationPlayer


var _playback_pause_timer : Timer


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)
	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)


func _on_playback_pause_timer_timeout() -> void:
	pause()


func _on_replay_manager_started_playback() -> void:
	stop(true)


func _save_state() -> Dictionary:
	var state = {}
	state.current_animation = current_animation
	state.current_animation_position = current_animation_position
	return state


func _load_state(state : Dictionary) -> void:
	if current_animation != state.current_animation:
		current_animation = state.current_animation
	seek(state.current_animation_position)

	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)
	pass
