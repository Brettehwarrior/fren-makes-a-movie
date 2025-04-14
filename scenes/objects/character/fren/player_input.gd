class_name PlayerInput
extends CharacterInput

@onready var mouse_sensitivity : float = SettingsManager.mouse_sensitivity_slider.value
@onready var controller_sensitivity : float = SettingsManager.controller_sensitivity_slider.value

var _mouse_input : Vector2
var _ignore_mouse_input : bool

var _previous_mouse_state

func _ready() -> void:
	_ignore_mouse_input = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SettingsManager.changed_visibility.connect(_on_settings_changed_visibility)
	SettingsManager.mouse_sensitivity_changed.connect(_on_settings_mouse_sensitivity_changed)
	SettingsManager.controller_sensitivity_changed.connect(_on_settings_controller_sensitivity_changed)
	await get_tree().create_timer(0.5).timeout
	_ignore_mouse_input = false


func _on_settings_changed_visibility(is_visible : bool) -> void:
	if is_visible:
		_previous_mouse_state = Input.mouse_mode
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if not ReplayManager.is_playing_back():
			if _previous_mouse_state:
				Input.mouse_mode = _previous_mouse_state
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_settings_mouse_sensitivity_changed(value : float) -> void:
	mouse_sensitivity = value


func _on_settings_controller_sensitivity_changed(value : float) -> void:
	controller_sensitivity = value


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not _ignore_mouse_input:
		_mouse_input += event.relative


func _process(_delta: float) -> void:
	_mouse_input = Vector2.ZERO


func get_horizontal_input() -> Vector2:
	var movement_input = Input.get_vector("move_left", "move_right", "move_down", "move_up").normalized()
	return movement_input


func get_look_input() -> Vector2:
	var controller_look_input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if controller_look_input.length() > 0:
		return controller_look_input * controller_sensitivity

	return _mouse_input * mouse_sensitivity


func is_camera_drop_button_just_presed() -> bool:
	return Input.is_action_just_pressed("camera_drop")


func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")


func is_sprint_held() -> bool:
	return Input.is_action_pressed("sprint")
