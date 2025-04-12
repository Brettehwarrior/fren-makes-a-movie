extends Node

@export var audio_stream_player_scene : PackedScene
@export var audio_stream_player_count : int = 32
var _audio_stream_players : Array[AudioStreamPlayer3D]
var _audio_stream_player_index : int = 0


func _ready() -> void:
	for i in range(audio_stream_player_count):
		var stream_player = audio_stream_player_scene.instantiate()
		add_child(stream_player)
		_audio_stream_players.append(stream_player)


func play_oneshot(audio_stream : AudioStream, global_position : Vector3, volume_db : float = 1) -> void:
	if ReplayManager.is_playing_back():
		return
	var stream_player : AudioStreamPlayer3D = _audio_stream_players[_audio_stream_player_index]
	stream_player.stream = audio_stream
	stream_player.volume_db = volume_db
	stream_player.global_position = global_position
	stream_player.play()
	_audio_stream_player_index += 1
	_audio_stream_player_index %= (audio_stream_player_count)


func play_oneshot_not_recorded(audio_stream : AudioStream, global_position : Vector3, volume_db : float = 0) -> void:
	var audio_stream_player = AudioStreamPlayer3D.new()
	audio_stream_player.stream = audio_stream
	audio_stream_player.volume_db = volume_db
	audio_stream_player.global_position = global_position
	audio_stream_player.finished.connect(func():audio_stream_player.queue_free())
	add_child(audio_stream_player)
	audio_stream_player.play()
