extends Node

@export var mic_stream_player : AudioStreamPlayer

var _record_bus_index : int
var _record_effect : AudioEffectRecord
var _last_recorded_clip : AudioStreamWAV

@export_category("Volume Level")
@export var mic_volume_progress_bar : ProgressBar
@export_range(1, 30) var samples_for_current_volume : int
var _current_mic_volume : float
var _recent_mic_volumes : Array[float] = []


func _ready() -> void:
	_record_bus_index = AudioServer.get_bus_index("Record")
	_record_effect = AudioServer.get_bus_effect(_record_bus_index, 0)


func _process(_delta):
	_process_volume()


func start_recording() -> void:
	_record_effect.set_recording_active(true)


func stop_recording() -> AudioStreamWAV:
	_record_effect.set_recording_active(false)
	_last_recorded_clip = _record_effect.get_recording()
	return _last_recorded_clip


func _process_volume() -> void:
	var volume_db = AudioServer.get_bus_peak_volume_left_db(_record_bus_index, 0)
	_current_mic_volume = db_to_linear(volume_db)
	_recent_mic_volumes.push_back(_current_mic_volume)

	if len(_recent_mic_volumes) > samples_for_current_volume:
		_recent_mic_volumes.pop_front()

	mic_volume_progress_bar.value = _get_average(_recent_mic_volumes)
	

func _get_average(list : Array[float]) -> float:
	var average = 0
	for item in list:
		average += item
	average /= len(list)
	return average


func get_current_mic_volume() -> float:
	return _get_average(_recent_mic_volumes)
