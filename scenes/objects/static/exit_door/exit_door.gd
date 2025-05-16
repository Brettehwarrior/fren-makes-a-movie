extends Node3D

@export var confirm_ui : Node # Are you sure?
@export var idiot_ui : Node # You haven't filmed anything yet, dummy

var _dialog_showing : bool = false


func _ready() -> void:
	_hide_confirm()
	_hide_idiot()


func _on_interaction_triggered() -> void:
	_show_confirm()


func _show_confirm() -> void:
	if not _dialog_showing and not ReplayManager.is_playing_back():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		confirm_ui.show()
		_dialog_showing = true
	

func _hide_confirm() -> void:
	_dialog_showing = false
	confirm_ui.hide()
	
	
func _show_idiot() -> void:
	if not ReplayManager.is_playing_back():
		_dialog_showing = true
		idiot_ui.show()
	

func _hide_idiot() -> void:
	_dialog_showing = false
	idiot_ui.hide()


func _on_complete_movie_pressed() -> void:
	if ReplayManager.get_current_recording_frame() > 0:
		_hide_confirm()
		ReplayManager.start_playback()
	else:
		_hide_confirm()
		_show_idiot()


func _on_continue_filming_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_hide_confirm()


func _on_forgor_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_hide_idiot()


func _input(event: InputEvent) -> void:
	# DEBUG STUFF
	if SettingsManager.debug_enabled:
		if event.is_action_pressed("debug_finish_movie") and ReplayManager.get_current_recording_frame() > 0:
			ReplayManager.start_playback()
