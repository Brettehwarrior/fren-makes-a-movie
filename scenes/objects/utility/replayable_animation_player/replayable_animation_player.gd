class_name ReplayableAnimationPlayer
extends AnimationPlayer


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)

func _on_replay_manager_started_playback() -> void:
	stop(true)
