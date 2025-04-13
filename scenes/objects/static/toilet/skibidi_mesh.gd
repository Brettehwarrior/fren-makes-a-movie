extends MeshInstance3D

func _save_state() -> Dictionary:
	var state = {}
	state.visible = visible
	return state


func _load_state(state : Dictionary) -> void:
	visible = state.visible

