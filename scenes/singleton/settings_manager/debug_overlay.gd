extends Control

@export var fren_position_label : Label
@export var fren_velocity_label : Label

func _process(_delta: float) -> void:
	if EventBus.global_fren_reference:
		fren_position_label.text = str("%.2v" % EventBus.global_fren_reference.global_position)
		fren_velocity_label.text = str("%.2v" % EventBus.global_fren_reference.velocity)
	else:
		fren_position_label.text = "???"