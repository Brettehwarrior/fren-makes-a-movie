extends Control

@export var interaction_label : RichTextLabel

func _process(_delta: float) -> void:
	# Interaction text
	if InteractionManager.interaction_name != "" and InteractionManager.interaction_keybind != "":
		interaction_label.text = InteractionManager.interaction_name + " [" + InteractionManager.interaction_keybind + "]"
		modulate = Color(225, 225, 0, 1)
	else:
		interaction_label.text = ""
		modulate = Color(225, 225, 225, 1)
		
	# Show or hide entire interaction HUD, including crosshair
	if SettingsManager.is_showing() or ReplayManager.is_playing_back():
		hide()
	else:
		show()
