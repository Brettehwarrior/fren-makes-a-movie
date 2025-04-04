extends RigidBody3D

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

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_down"):
        ReplayManager.start_recording()
    elif Input.is_action_just_released("ui_down"):
        ReplayManager.stop_recording()