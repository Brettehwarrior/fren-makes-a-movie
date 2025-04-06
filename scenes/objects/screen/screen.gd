extends Node3D

@export var stream_player : VideoStreamPlayer

var _playback_pause_timer : Timer
var _previously_loaded_stream_position : float

func _ready():
	play_at_position(500.0) # Debug stuff, delete me
	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)
	stream_player.volume = 0

func _save_state() -> Dictionary:
	var state = {}
	state.stream_position = stream_player.stream_position
	return state
	
func _load_state(state : Dictionary) -> void:
	if stream_player.paused or abs(stream_player.stream_position - _previously_loaded_stream_position) >= ReplayManager.get_tick_rate() * 2:
		# print("setting stream position to %f!" % [state.stream_position])
		stream_player.stream_position = (state.stream_position)
		set_paused(false)
	
	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)

	_previously_loaded_stream_position = state.stream_position

func _on_playback_pause_timer_timeout() -> void:
	set_paused(true)


func set_paused(value : bool) -> void:
	stream_player.paused = value


func play():
	stream_player.play()


func play_at_position(seconds : float):
	stream_player.play()
	stream_player.stream_position = seconds


func stop():
	stream_player.stop()
