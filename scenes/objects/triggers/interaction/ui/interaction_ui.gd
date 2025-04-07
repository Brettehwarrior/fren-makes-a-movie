extends Control

@export var interaction_label : RichTextLabel

func _process(_delta: float) -> void:
	if InteractionManager.interaction_name != "" and InteractionManager.interaction_keybind != "":
		interaction_label.text = InteractionManager.interaction_name + " [" + InteractionManager.interaction_keybind + "]"
		modulate = Color(225, 225, 0, 1)
	else:
		interaction_label.text = ""
		modulate = Color(225, 225, 225, 1)
