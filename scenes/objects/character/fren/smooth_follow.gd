extends Node3D

@export var follow_target : Node3D
@export var speed_factor : float

func _ready() -> void:
	position = follow_target.position

func _process(delta):
	position += ((follow_target.global_position - position) / speed_factor) * delta
