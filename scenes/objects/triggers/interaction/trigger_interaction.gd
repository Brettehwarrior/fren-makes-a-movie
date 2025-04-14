extends Node3D

signal interaction_triggered
signal interaction_range_entered
signal interaction_range_exited

@export var interaction_name : String = "interact"
@export var interaction_keybind : String = "LMB"
@export var interaction_input_action : String = "interact"

func on_interaction_triggered():
	interaction_triggered.emit()

func on_interaction_range_entered():
	if ReplayManager.is_playing_back():
		return
	InteractionManager.set_interaction_display(interaction_name, interaction_keybind)
	print(get_path())
	interaction_range_entered.emit()

func on_interaction_range_exited():
	if ReplayManager.is_playing_back():
		return
	InteractionManager.clear_interaction_display()
	interaction_range_exited.emit()
