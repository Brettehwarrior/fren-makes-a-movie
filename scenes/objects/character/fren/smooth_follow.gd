extends Node3D

@export var follow_target : Node3D
@export var speed_factor : float

func _ready() -> void:
	position = follow_target.position

func _process(delta):
	var position_difference = (follow_target.global_position - position)
	var scaled_position_delta = (position_difference / speed_factor) * delta
	if scaled_position_delta.length_squared() > position_difference.length_squared():
		scaled_position_delta = scaled_position_delta.normalized()
		scaled_position_delta *= position_difference.length()
	position += scaled_position_delta
