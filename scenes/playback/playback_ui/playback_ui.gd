extends Control

@export var video_playback_texture : TextureRect

@export var timeline : Control
@export var viewcount_field : LineEdit

@export var play_pause_button : Button
@export var play_icon : Texture2D
@export var pause_icon : Texture2D

@export var frame_slider : Slider
@export var current_time_label : Label
@export var total_time_label : Label

@export var restart_prompt_control : Control

var _is_playing : bool = false
var _timeline_opacity : float
var _timeline_hide_cooldown : float = 1.0
var _timeline_hide_timer : float
var _viewcount : int = 0


func _ready() -> void:
	restart_prompt_control.visible = false
	visible = false
	ReplayManager.started_playback.connect(_initialize)
	ReplayManager.playback_camera_created.connect(_on_playback_camera_created)
	

func _process(delta: float) -> void:
	_process_timeline_alpha(delta)
	_process_playback(delta)


func _process_timeline_alpha(delta : float) -> void:
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


func _process_playback(delta : float) -> void:
	if not ReplayManager.is_playing_back():
		return

	if _is_playing:
		frame_slider.value += delta / ReplayManager.get_current_seconds()
	
	current_time_label.text = _format_time(frame_slider.value * ReplayManager.get_current_seconds())


func _on_playback_camera_created(subviewport : SubViewport) -> void:
	video_playback_texture.texture = subviewport.get_texture()


func _initialize() -> void:
	visible = true
	# frame_slider.max_value = ReplayManager.get_current_recording_frame() - 1
	total_time_label.text = _format_time(ReplayManager.get_current_seconds())
	_timeline_opacity = 1.0
	_timeline_hide_timer = _timeline_hide_cooldown
	assert(frame_slider.max_value > 0, "ReplayManager has no frames recorded")



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


	_load_game_state(value / frame_slider.max_value)


func _load_game_state(time_percentage : float) -> void:
	var tick = int(time_percentage * ReplayManager.get_current_recording_frame())
	ReplayManager.load_game_state(tick)


func _on_frame_slider_drag_started() -> void:
	_is_playing = false
	_update_play_pause_button_icon()


func _on_new_movie_pressed() -> void:
	restart_prompt_control.visible = true


func _on_restart_button_pressed() -> void:
	ReplayManager.reset()
	MainScene.load_initial_world()


func _on_cancel_restart_button_pressed() -> void:
	restart_prompt_control.visible = false


func _on_timer_timeout() -> void:
	_viewcount += randi_range(7, 6883)
	viewcount_field.text = _format_with_commas(_viewcount) + " views"
	$Timer.start(1)


func _format_with_commas(value: int) -> String:
	var str_val := str(abs(value))
	var result := ""
	var count := 0
	
	for i in range(str_val.length() - 1, -1, -1):
		result = str_val[i] + result
		count += 1
		if count % 3 == 0 and i != 0:
			result = "," + result
	
	if value < 0:
		result = "-" + result
	
	return result


func _format_time(seconds: float) -> String:
	var minutes = int(seconds / 60)
	var seconds_remaining = int(int(seconds) % 60)
	return "%02d:%02d" % [minutes, seconds_remaining]


func _on_export_pressed() -> void:
	ReplayManager.start_export()
