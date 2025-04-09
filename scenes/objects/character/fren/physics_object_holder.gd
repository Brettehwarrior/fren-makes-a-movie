extends Node3D

@export var joint : Generic6DOFJoint3D

var _currently_held_object : ReplayableRigidBody3D


func _ready() -> void:
	EventBus.physics_object_interacted_with.connect(_on_physics_object_interacted_with)


func _on_physics_object_interacted_with(object : ReplayableRigidBody3D) -> void:
	if _currently_held_object == null:
		_currently_held_object = object
		joint.node_a = _currently_held_object.get_path()
	else:
		_currently_held_object = null
		joint.node_a = ""
