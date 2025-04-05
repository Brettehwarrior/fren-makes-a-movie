class_name PlayerInput
extends Node


@export var mouse_sensitivity : float = 1

var _mouse_input : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_input += event.relative


func _process(delta: float) -> void:
	_mouse_input = Vector2.ZERO


func get_horizontal_input() -> Vector2:
	var movement_input = Input.get_vector("move_left", "move_right", "move_down", "move_up").normalized()
	return movement_input


func get_look_input() -> Vector2:
	var controller_look_input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if controller_look_input.length() > 0:
		return controller_look_input

	return _mouse_input * mouse_sensitivity
