class_name Camcorder
extends Node3D

@export var _follow_speed_factor : float

var _follow_position_node : Node3D
var _follow_rotation_node : Node3D


func _ready() -> void:
	ReplayManager.register_camera(self)


func _process(delta: float) -> void:
	if _follow_position_node != null:
		position += ((_follow_position_node.global_position - position) / _follow_speed_factor) * delta
	if _follow_rotation_node != null:
		rotation = _follow_rotation_node.global_rotation


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_record"):
		ReplayManager.start_recording()
	elif event.is_action_released("camera_record"):
		ReplayManager.stop_recording()


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = position
	state.rotation = rotation
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	rotation = state.rotation


func reset_follow_nodes() -> void:
	set_follow_position_node(null)
	set_follow_rotation_node(null)

func set_follow_position_node(node : Node3D) -> void:
	_follow_position_node = node


func set_follow_rotation_node(node : Node3D) -> void:
	_follow_rotation_node = node


func is_held() -> bool:
	return _follow_position_node != null
