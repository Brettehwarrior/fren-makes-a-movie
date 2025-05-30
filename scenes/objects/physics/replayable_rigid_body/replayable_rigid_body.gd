class_name ReplayableRigidBody3D
extends RigidBody3D

func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)


func _on_replay_manager_started_playback() -> void:
	freeze = true
