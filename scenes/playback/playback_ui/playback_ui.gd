extends Control

@export var video_playback_texture : TextureRect

@export var timeline : Control
@export var viewcount_field : LineEdit

@export var play_pause_button : Button
@export var play_icon : Texture2D
@export var pause_icon : Texture2D

@export var frame_slider : Slider
@export var current_frame_label : Label
@export var total_frames_label : Label

var _is_playing : bool = false
var _timeline_opacity : float
var _timeline_hide_cooldown : float = 1.0
var _timeline_hide_timer : float
var _viewcount : int = 0
var _maxviews : int = 1000000000


func _ready() -> void:
	visible = false
	ReplayManager.started_playback.connect(_initialize)
	ReplayManager.playback_camera_created.connect(_on_playback_camera_created)
	

func _process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		if timeline.get_global_rect().has_point(timeline.get_global_mouse_position()):
			_timeline_opacity = 1.0
			_timeline_hide_timer = _timeline_hide_cooldown
		else:
			if _timeline_hide_timer <= 0:
				_timeline_opacity = 0.0
			else:
				_timeline_hide_timer -= delta
	
	timeline.modulate.a = lerp(timeline.modulate.a, _timeline_opacity, delta * 20)
	_viewcount = lerp(_viewcount, _maxviews, delta * 0.000001)
	viewcount_field.text = str(_viewcount) + " views"


func _on_playback_camera_created(subviewport : SubViewport) -> void:
	video_playback_texture.texture = subviewport.get_texture()


func _initialize() -> void:
	visible = true
	frame_slider.max_value = ReplayManager.get_current_recording_frame() - 1
	total_frames_label.text = str(int(frame_slider.max_value))
	_timeline_opacity = 1.0
	_timeline_hide_timer = _timeline_hide_cooldown
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


func _on_title_screen_pressed() -> void:
	pass


func _on_new_movie_pressed() -> void:
	pass
