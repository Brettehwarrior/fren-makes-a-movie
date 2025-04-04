extends Control

@export var recording_status_label : Label
@export var frame_spin_box : SpinBox

func _process(_delta: float) -> void:
	frame_spin_box.max_value = ReplayManager.get_current_recording_frame() - 1

	if ReplayManager.is_recording():
		recording_status_label.text = "Recording\n[Frame %d]" % ReplayManager.get_current_recording_frame()
	else:
		recording_status_label.text = "Not Recording\n[Frame %d]" % ReplayManager.get_current_recording_frame()


func _on_toggle_recording_button_pressed() -> void:
	if ReplayManager.is_recording():
		ReplayManager.stop_recording()
	else:
		ReplayManager.start_recording()


func _on_load_frame_button_pressed() -> void:
	ReplayManager.load_game_state(int(frame_spin_box.value))
