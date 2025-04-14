extends Node3D

@export var stream_player : VideoStreamPlayer
@export var audio_origin_node : Node3D
@export var volume_attenuation_curve : Curve
@export var max_attenuation_distance : float

var _playback_pause_timer : Timer
var _previously_loaded_stream_position : float
var _previously_loaded_movie : String

@onready var _active_camera : Camera3D = get_viewport().get_camera_3d()

func _ready():
	play_at_position(583.2) # Debug stuff, delete me?
	_playback_pause_timer = Timer.new()
	_playback_pause_timer.timeout.connect(_on_playback_pause_timer_timeout)
	add_child(_playback_pause_timer)
	
	ReplayManager.started_playback.connect(_on_replay_manager_start_playback)
	ReplayManager.playback_camera_created.connect(_on_replay_manager_playback_camera_created)


func _on_replay_manager_start_playback() -> void:
	stream_player.bus = "CameraRecordedPlayback"


func _on_replay_manager_playback_camera_created(viewport : SubViewport) -> void:
	_active_camera = viewport.get_camera_3d()


func _process(_delta: float) -> void:
	var distance_to_camera = (audio_origin_node.global_position - _active_camera.global_position).length()
	var distance_percentage = remap(distance_to_camera, 0, max_attenuation_distance, 0, 1)
	stream_player.volume = volume_attenuation_curve.sample(distance_percentage)


func _save_state() -> Dictionary:
	var state = {}
	state.stream_position = stream_player.stream_position
	state.movie = stream_player.stream.file
	return state
	

func _load_state(state : Dictionary) -> void:
	if _previously_loaded_movie != state.movie:
		load_movie(state.movie)
	
	if stream_player.paused or abs(stream_player.stream_position - _previously_loaded_stream_position) >= ReplayManager.get_tick_rate() * 2:
		# print("setting stream position to %f!" % [state.stream_position])
		stream_player.stream_position = (state.stream_position)
		set_paused(false)
	
	_playback_pause_timer.stop()
	_playback_pause_timer.start(ReplayManager.get_tick_rate() * 2)

	_previously_loaded_stream_position = state.stream_position
	_previously_loaded_movie = state.movie


func _on_playback_pause_timer_timeout() -> void:
	set_paused(true)

func set_paused(value : bool) -> void:
	stream_player.paused = value

func load_movie(path : String):
	stream_player.stream.file = path
	play()

func play():
	stream_player.play()

func play_at_position(seconds : float):
	stream_player.play()
	stream_player.stream_position = seconds

func stop():
	stream_player.stop()
