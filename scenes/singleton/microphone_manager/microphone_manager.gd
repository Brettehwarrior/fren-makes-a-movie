extends Node

@export var mic_volume_progress_bar : ProgressBar

@export_range(1, 30) var samples_for_current_volume : int

var _current_mic_volume : float
var _recent_mic_volumes : Array[float] = []

func _process(_delta):
	var volume_db = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0)
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
