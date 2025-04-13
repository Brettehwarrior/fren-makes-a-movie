extends Node3D

@export var riff_stream : AudioStream
@export var skibidi_node : Node3D

var _has_skibidid : bool = false


func _on_area_3d_body_entered(body:Node3D) -> void:
	if body is not Fren:
		return
	if not _has_skibidid:
		_has_skibidid = true
		AudioManager.play_oneshot(riff_stream, global_position)
		skibidi_node.visible = true
