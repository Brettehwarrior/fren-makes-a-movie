extends Control

@export var play_pause_button : Button
@export var play_icon : Texture2D
@export var pause_icon : Texture2D

@export var frame_slider : Slider
@export var current_frame_label : Label
@export var total_frames_label : Label

var _is_playing : bool = false


func _ready() -> void:
	visible = false
	ReplayManager.started_playback.connect(_initialize)


func _initialize() -> void:
	visible = true
	frame_slider.max_value = ReplayManager.get_current_recording_frame() - 1
	total_frames_label.text = str(int(frame_slider.max_value))
	assert(frame_slider.max_value > 0, "ReplayManager has no frames recorded")


func _tick() -> void:
	if not ReplayManager.is_playing_back():
		return

	if _is_playing:
		frame_slider.value += 1
	current_frame_label.text = str(int(frame_slider.value))


func _on_play_pause_button_pressed() -> void:
	if frame_slider.value >= frame_slider.max_value:
		_is_playing = true
		_update_play_pause_button_icon()
		frame_slider.value = 0
		return
	
	_is_playing = not _is_playing
	_update_play_pause_button_icon()


func _update_play_pause_button_icon() -> void:
	play_pause_button.icon = pause_icon if _is_playing else play_icon


func _on_frame_slider_value_changed(value:float) -> void:
	if value >= frame_slider.max_value:
		_is_playing = false
		_update_play_pause_button_icon()
	_load_game_state(int(value))


func _load_game_state(frame : int) -> void:
	ReplayManager.load_game_state(frame)


func _on_frame_slider_drag_started() -> void:
	_is_playing = false
	_update_play_pause_button_icon()
