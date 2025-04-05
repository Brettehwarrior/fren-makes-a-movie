extends Node3D

@export var stream_player : VideoStreamPlayer

var _recording_position : float = 0.0
var _playback_position : float = 0.0

func _ready():
	ReplayManager.started_recording.connect(started_recording)
	
	# Debug stuff, delete me
	play_at_position(5.0)
	#stream_player.volume = 0

func play():
	stream_player.play()
	
func play_at_position(seconds : float):
	stream_player.play()
	stream_player.stream_position = seconds
	
func stop():
	stream_player.stop()

func started_recording():
	_recording_position = stream_player.stream_position

func _save_state() -> Dictionary:
	var state = {}
	state.position = _recording_position
	return state
	
func _load_state(state : Dictionary) -> void:
	if (state.position != _playback_position):
		play_at_position(state.position)
		_playback_position = state.position
