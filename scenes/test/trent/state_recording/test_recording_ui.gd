extends Control

@export var recording_status_label : Label


func _process(_delta: float) -> void:
	if ReplayManager.is_recording():
		recording_status_label.text = "Recording\n[Frame %d]" % ReplayManager.get_current_recording_frame()
	else:
		recording_status_label.text = "Not Recording\n[Frame %d]" % ReplayManager.get_current_recording_frame()


func _on_toggle_recording_button_pressed() -> void:
	if ReplayManager.is_recording():
		ReplayManager.stop_recording()
	else:
		ReplayManager.start_recording()


func _on_start_playback_button_pressed() -> void:
	ReplayManager.start_playback()
	visible = false
