extends Node3D

@export var stream_player : VideoStreamPlayer
@export var audio_origin_node : Node3D
@export var volume_attenuation_curve : Curve
@export var max_attenuation_distance : float


@onready var _active_camera : Camera3D = get_viewport().get_camera_3d()

func _ready():
	play_at_position(583.2) # Debug stuff, delete me?
	ReplayManager.started_playback.connect(_on_replay_manager_start_playback)


func _on_replay_manager_start_playback() -> void:
	stream_player.bus = "CameraRecordedPlayback"


func _process(_delta: float) -> void:
	var distance_to_camera = (audio_origin_node.global_position - _active_camera.global_position).length()
	var distance_percentage = remap(distance_to_camera, 0, max_attenuation_distance, 0, 1)
	stream_player.volume = volume_attenuation_curve.sample(distance_percentage)


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
