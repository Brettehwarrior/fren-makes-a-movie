extends Control

@export var always_show_progress_bar : bool
@export var recording_progress_bar : ProgressBar
@export var rec_indicator : Control
@export var current_recording_time_label : Label
@export var max_recording_time_label : Label


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)
	ReplayManager.started_recording.connect(_on_replay_manager_started_recording)
	ReplayManager.stopped_recording.connect(_on_replay_manager_stopped_recording)
	EventBus.camcorder_dropped.connect(_on_camcorder_dropped)
	EventBus.camcorder_picked_up.connect(_on_camcorder_picked_up)

	if always_show_progress_bar:
		visible = true
	else:
		visible = false
	
	max_recording_time_label.text = format_time(ReplayManager.get_maximum_seconds())


func format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var seconds_remaining = int(int(seconds) % 60)
	return "%02d:%02d" % [minutes, seconds_remaining]


func _on_replay_manager_started_playback() -> void:
	queue_free()


func _on_replay_manager_started_recording() -> void:
	rec_indicator.visible = true


func _on_replay_manager_stopped_recording() -> void:
	rec_indicator.visible = false


func _on_camcorder_dropped() -> void:
	if always_show_progress_bar:
		return
	visible = true


func _on_camcorder_picked_up() -> void:
	if always_show_progress_bar:
		return
	visible = false


func _process(_delta: float) -> void:
	recording_progress_bar.value = ReplayManager.get_recording_progress_percentage()
	current_recording_time_label.text = format_time(ReplayManager.get_current_seconds())
