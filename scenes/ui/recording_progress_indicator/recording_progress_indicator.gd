extends Control

@export var recording_progress_bar : ProgressBar


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)


func _on_replay_manager_started_playback() -> void:
	visible = false


func _process(_delta: float) -> void:
	recording_progress_bar.value = ReplayManager.get_recording_progress_percentage()
