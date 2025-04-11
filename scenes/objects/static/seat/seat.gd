extends Node3D


func _on_sit_trigger_area_body_entered(body:Node3D) -> void:
	if body.has_method("start_sitting"):
		body.start_sitting()


func _on_sit_trigger_area_body_exited(body:Node3D) -> void:
	if body.has_method("stop_sitting"):
		body.stop_sitting()
