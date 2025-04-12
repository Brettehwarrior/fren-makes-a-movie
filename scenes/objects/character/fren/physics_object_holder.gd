extends Node3D

@export var joint : Generic6DOFJoint3D

var _currently_held_object : ReplayableRigidBody3D


func _ready() -> void:
	EventBus.physics_object_interacted_with.connect(_on_physics_object_interacted_with)


func _input(event: InputEvent) -> void:
	if ReplayManager.is_playing_back():
		return
	
	if event.is_action_released("interact"):
		_drop_object()


func _on_physics_object_interacted_with(object : ReplayableRigidBody3D) -> void:
	if _currently_held_object == null:
		_grab_object(object)
	# else:
	# 	_drop_object()

func _grab_object(object : ReplayableRigidBody3D) -> void:
	_currently_held_object = object
	joint.node_a = _currently_held_object.get_path()
	joint.position += (joint.position - object.position)

func _drop_object() -> void:
	_currently_held_object = null
	joint.node_a = ""
	joint.position = Vector3.ZERO