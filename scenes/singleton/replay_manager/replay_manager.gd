extends Node

signal started_recording
signal stopped_recording

@export var ticks_per_second : float = 60 
@onready var tick_rate : float = 1 / ticks_per_second
var _time_since_last_tick : float = 0

var _is_recording : bool = false
var _current_recording_frame : int = 0


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
	if _time_since_last_tick >= tick_rate:
		_tick()
		_time_since_last_tick = 0


func _tick() -> void:
	var replayable_nodes : Array[Node] = get_tree().get_nodes_in_group("replayable")

	_tick_nodes(replayable_nodes)	
	_tick_recording(replayable_nodes)


func _tick_nodes(nodes : Array[Node]) -> void:
	for node in nodes:
		if node.has_method("_tick"):
			node._tick()


func _tick_recording(nodes : Array[Node]) -> void:
	if not _is_recording:
		return
	
	for node in nodes:
		if node.has_method("_save_state"):
			_record_node_state(node)
	
	_current_recording_frame += 1


func _record_node_state(node : Node) -> void:
	var node_state : Dictionary = node._save_state()
	var node_frame_data = NodeFrameData.new(_current_recording_frame, node_state)

	var node_path = str(node.get_path())
	var frame_history : NodeFrameDataHistory = _recorded_objects.get_or_add(node_path, NodeFrameDataHistory.new())
	
	frame_history.list.append(node_frame_data)


func load_game_state(frame : int) -> void:
	var replayable_nodes : Array[Node] = get_tree().get_nodes_in_group("replayable")

	for node in replayable_nodes:
		if node.has_method("_load_state"):
			var node_path = str(node.get_path())
			var frame_history : NodeFrameDataHistory = _recorded_objects.get(node_path)
			var state_to_load : Dictionary
			for frame_data in frame_history.list:
				if frame_data.frame_index == frame:
					state_to_load = frame_data.node_state
					break
			node._load_state(state_to_load)


func start_recording() -> void:
	_is_recording = true
	started_recording.emit()


func stop_recording() -> void:
	_is_recording = false
	stopped_recording.emit()


func is_recording() -> bool:
	return _is_recording

func get_current_recording_frame() -> int:
	return _current_recording_frame
