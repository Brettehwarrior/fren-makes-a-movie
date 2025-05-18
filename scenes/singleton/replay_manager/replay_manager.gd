extends Node

signal started_recording
signal stopped_recording
signal started_playback
signal playback_camera_created(viewport : SubViewport)


@export var ticks_per_second : float = 60 
@onready var _tick_rate : float = 1 / ticks_per_second
var _time_since_last_tick : float = 0

@export var maximum_seconds : float = 60
@onready var _maximum_recording_frames : int = maximum_seconds / _tick_rate

var _is_recording : bool = false
var _is_playing_back : bool = false
var _current_recording_frame : int = 0

var _playback_subviewport : SubViewport
var _playback_camera : Camera3D
var _playback_object_id : String

class NodeFrameDataHistory:
	var list : Array[NodeFrameData]
	func _init() -> void:
		list = []

class NodeFrameData:
	var frame_index : int
	var node_state : Dictionary
	func _init(_frame_index : int, _node_state : Dictionary) -> void:
		self.frame_index = _frame_index
		self.node_state = _node_state.duplicate()


var _recorded_objects : Dictionary[String, NodeFrameDataHistory]


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
	
	var replayable_nodes : Array[Node] = get_tree().get_nodes_in_group("replayable")
	_tick_recording(replayable_nodes)


func _tick_nodes(nodes : Array[Node]) -> void:
	for node in nodes:
		if node.has_method("_tick"):
			node._tick()


func _tick_recording(nodes : Array[Node]) -> void:
	if not _is_recording:
		return
	
	if _current_recording_frame >= _maximum_recording_frames:
		stop_recording()
		return
	
	for node in nodes:
		if node.has_method("_save_state"):
			_record_node_state(node)
	
	_current_recording_frame += 1


func _record_node_state(node : Node) -> void:
	var node_state : Dictionary = node._save_state()
	var node_frame_data = NodeFrameData.new(_current_recording_frame, node_state)

	var node_id = _get_node_id(node)
	var frame_history : NodeFrameDataHistory = _recorded_objects.get_or_add(node_id, NodeFrameDataHistory.new())
	
	if len(frame_history.list) > 0:
		var previous_recorded_frame_data = frame_history.list[-1]
		var previous_frame_state_hash = previous_recorded_frame_data.node_state.hash()
		var current_frame_state_hash = node_frame_data.node_state.hash()
		if current_frame_state_hash == previous_frame_state_hash:
			return

	frame_history.list.append(node_frame_data)


func _get_node_id(node : Node) -> String:
	var id = str(node)
	return id


func load_game_state(frame : int) -> void:
	var replayable_nodes : Array[Node] = get_tree().get_nodes_in_group("replayable")

	for node in replayable_nodes:
		if node.has_method("_load_state"):
			var node_id = _get_node_id(node)
			var frame_history : NodeFrameDataHistory = _recorded_objects.get(node_id)
			var state_to_load : Dictionary = {}
			
			var list = frame_history.list
			var low = 0
			var high = list.size() - 1
			var closest_index = 0

			while low <= high:
				var mid = (low + high) / 2
				var frame_data = list[mid]
				
				if frame_data.frame_index == frame:
					closest_index = mid
					break
				elif frame_data.frame_index < frame:
					closest_index = mid
					low = mid + 1
				else:
					high = mid - 1

			state_to_load = list[closest_index].node_state

			node._load_state(state_to_load)

			if _is_playing_back and node_id == _playback_object_id:
				_playback_camera.global_position = node.global_position
				_playback_camera.global_rotation = node.global_rotation


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


func register_playback_camera(node : Node) -> void:
	assert(_playback_object_id == "", "Tried to register second camera")
	_playback_object_id = _get_node_id(node)


func start_playback() -> void:
	if _is_recording:
		stop_recording()

	_setup_playback_camera()
	_is_playing_back = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	load_game_state(0)
	started_playback.emit()


func _setup_playback_camera() -> void:
	_playback_subviewport = SubViewport.new()
	_playback_subviewport.size = Vector2i(720, 480)
	_playback_subviewport.name = "PlaybackViewport"
	get_tree().root.add_child(_playback_subviewport) # TODO: For playing a second time this will have to be destroyed

	_playback_camera = Camera3D.new()
	_playback_camera.name = "PlaybackCamera"
	_playback_camera.make_current()
	_playback_subviewport.add_child(_playback_camera)

	playback_camera_created.emit(_playback_subviewport)


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
	_playback_camera.queue_free()
	_playback_subviewport.queue_free()
	_current_recording_frame = 0
	_playback_object_id = ""
	
	_recorded_objects = {}
