extends Node3D

signal interaction_triggered
signal interaction_range_entered
signal interaction_range_exited

@export var interaction_name : String = "interact"
@export var interaction_keybind : String = "E"
@export var interaction_input_action : String = "interact"

func on_interaction_triggered():
	interaction_triggered.emit()

func on_interaction_range_entered():
	print("enter")
	InteractionManager.set_interaction_display(interaction_name, interaction_keybind)
	interaction_range_entered.emit()

func on_interaction_range_exited():
	print("exit")
	InteractionManager.clear_interaction_display()
	interaction_range_exited.emit()
