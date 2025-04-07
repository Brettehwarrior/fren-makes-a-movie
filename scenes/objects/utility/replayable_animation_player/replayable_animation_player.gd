class_name ReplayableAnimationPlayer
extends AnimationPlayer


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)


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
	pass

