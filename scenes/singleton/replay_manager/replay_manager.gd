extends Node

signal started_recording
signal stopped_recording
signal started_playback


@export var ticks_per_second : float = 60 
@onready var _tick_rate : float = 1 / ticks_per_second
var _time_since_last_tick : float = 0

@export var maximum_seconds : float = 60
@onready var _maximum_recording_frames : int = maximum_seconds / _tick_rate

var _is_recording : bool = false
var _is_playing_back : bool = false
var _current_recording_frame : int = 0


func _process(delta: float) -> void:
	_process_tick(delta)


func _process_tick(delta : float) -> void:
	_time_since_last_tick += delta

	while _time_since_last_tick >= _tick_rate:
		_tick()
		_time_since_last_tick -= _tick_rate


func _tick() -> void:
	var tickable_nodes : Array[Node] = get_tree().get_nodes_in_group("tickable")
	_tick_nodes(tickable_nodes)

	if _is_playing_back:
		return
	
	_tick_recording()


func _tick_nodes(nodes : Array[Node]) -> void:
	for node in nodes:
		if node.has_method("_tick"):
			node._tick()


func _tick_recording() -> void:
	if not _is_recording:
		return
	
	if _current_recording_frame >= _maximum_recording_frames:
		stop_recording()
		return
	
	_current_recording_frame += 1


func start_recording() -> void:
	assert(not _is_recording, "Tried to start recording when already recording")
	if _current_recording_frame >= _maximum_recording_frames:
		print("Tried to record but max frames achieved")
		return
	_is_recording = true
	started_recording.emit()


func stop_recording() -> void:
	assert(_is_recording, "Tried to stop recording when wasn't recording")
	_is_recording = false
	stopped_recording.emit()


func start_playback() -> void:
	if _is_recording:
		stop_recording()

	_is_playing_back = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	started_playback.emit()


func is_playing_back() -> bool:
	return _is_playing_back


func is_recording() -> bool:
	return _is_recording


func get_current_recording_frame() -> int:
	return _current_recording_frame


func get_tick_rate() -> float:
	return _tick_rate


func get_maximum_seconds() -> float:
	return maximum_seconds


func get_current_seconds() -> float:
	return _current_recording_frame * _tick_rate


func get_recording_progress_percentage() -> float:
	return float(_current_recording_frame) / float(_maximum_recording_frames)


func reset() -> void:
	if is_recording():
		stop_recording()
	_is_playing_back = false
	_current_recording_frame = 0
