extends Node


@export var mic_volume_progress_bar : ProgressBar

var _current_mic_volume : float

func _process(_delta):
	var volume_db = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0)
	_current_mic_volume = db_to_linear(volume_db)
	mic_volume_progress_bar.value = _current_mic_volume
	print(_current_mic_volume)
