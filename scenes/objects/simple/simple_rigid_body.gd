extends RigidBody3D

func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)


func _on_replay_manager_started_playback() -> void:
	freeze = true


func _save_state() -> Dictionary:
	var state = {}
	state.position = position
	state.rotation = rotation
	state.linear_velocity = linear_velocity
	state.angular_velocity = angular_velocity
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	rotation = state.rotation
	linear_velocity = state.linear_velocity
	angular_velocity = state.angular_velocity


func _tick() -> void:
	pass #print("tick!")
