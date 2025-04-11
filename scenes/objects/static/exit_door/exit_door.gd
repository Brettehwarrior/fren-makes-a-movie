extends Node3D


func _on_area_3d_body_entered(body:Node3D) -> void:
	if not body is Fren:
		return
	if ReplayManager.get_current_recording_frame() > 0:
		ReplayManager.start_playback()
