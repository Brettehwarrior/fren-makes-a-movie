extends Node3D

func _ready() -> void:
	ReplayManager.register_camera(self)


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = position
	state.rotation = rotation
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	rotation = state.rotation

