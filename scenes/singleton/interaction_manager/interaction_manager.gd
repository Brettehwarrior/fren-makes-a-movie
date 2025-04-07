extends Node

var interaction_name : String
var interaction_keybind : String

func set_interaction_display(new_name : String, new_keybind : String):
	interaction_name = new_name
	interaction_keybind = new_keybind
	
func clear_interaction_display():
	interaction_name = ""
	interaction_keybind = ""
