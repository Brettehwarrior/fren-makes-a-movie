extends Control

@export var crosshair_parent : Control
@export var interaction_label : RichTextLabel

func _process(_delta: float) -> void:
	# Interaction text
	if InteractionManager.interaction_name != "" and InteractionManager.interaction_keybind != "":
		interaction_label.text = "[img={30}]uid://do173ynst785x[/img]" + InteractionManager.interaction_name
		crosshair_parent.modulate = Color(225, 225, 0, 1)
	else:
		interaction_label.text = ""
		crosshair_parent.modulate = Color(225, 225, 225, 1)
		
	# Show or hide entire interaction HUD, including crosshair
	if SettingsManager.is_showing() or ReplayManager.is_playing_back():
		hide()
	else:
		show()
