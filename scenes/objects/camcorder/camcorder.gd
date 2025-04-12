class_name Camcorder
extends Node3D

@export var camera : Node3D
@export var viewfinder : Node3D
@export var viewport : Node3D
@export var fren : Node3D

@export var pickup_stream : AudioStream
@export var drop_stream : AudioStream

var _parent_node : Node3D
var _original_parent_node : Node


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)
	ReplayManager.register_playback_camera(self)
	_original_parent_node = get_parent()
	_parent_node = _original_parent_node
	
	if fren == null:
		push_error("Fren node is not attached to the camcorder! Viewfinder flipping is disabled.")

func _on_replay_manager_started_playback() -> void:
	reset_follow_nodes()


func _process(delta: float) -> void:
	camera.rotation = global_rotation
	_viewfinder_follow_player(delta)


func _viewfinder_follow_player(delta: float) -> void:
	if (fren != null):
		var dir = to_local(fren.global_transform.origin).normalized()
		var player_in_front : bool = dir.z < 0
		var target_rotation = 0.0
		
		if not is_held() and player_in_front:
			target_rotation = -180.0
			viewport.rotation_degrees.z = 180.0
		else:
			viewport.rotation_degrees.z = 0.0
			target_rotation = 0.0
		
		viewfinder.rotation_degrees.x = lerp(viewfinder.rotation_degrees.x, target_rotation, delta * 10.0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_record") and not ReplayManager.is_recording():
		ReplayManager.start_recording()
	elif event.is_action_released("camera_record") and ReplayManager.is_recording():
		ReplayManager.stop_recording()


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = global_position
	state.rotation = global_rotation
	return state


func _load_state(state : Dictionary) -> void:
	global_position = state.position
	global_rotation = state.rotation


func reset_follow_nodes() -> void:
	_parent_node = _original_parent_node
	reparent(_original_parent_node)
	AudioManager.play_oneshot(drop_stream, global_position)
	EventBus.camcorder_dropped.emit()

func set_follow_position_node(node : Node3D) -> void:
	_parent_node = node
	reparent(node)
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	AudioManager.play_oneshot(pickup_stream, global_position)
	EventBus.camcorder_picked_up.emit()


func is_held() -> bool:
	return _parent_node != _original_parent_node
