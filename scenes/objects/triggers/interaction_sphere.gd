extends Node3D

signal interaction_triggered

@export var interaction_name : String = "interact"
@export var interaction_input_text : String = "E"
@export var interaction_input_action : String = "interact"

var _interaction_label : Label3D
var _touching_player : bool = false

func _ready() -> void:
	_interaction_label = $InteractionLabel
	_interaction_label.hide()
	_interaction_label.text = interaction_name + " [" + interaction_input_text + "]"
	
	var parent_scale = get_parent().scale
	scale = Vector3(1 / parent_scale.x, 1 / parent_scale.y, 1 / parent_scale.z)
	
func _input(event) -> void:
	if _touching_player and event.is_action_pressed(interaction_input_action):
		interaction_triggered.emit()
		print(interaction_name + " triggered!")

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not ReplayManager.is_playing_back():
		_interaction_label.show()
		_touching_player = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		_interaction_label.hide()
		_touching_player = false
