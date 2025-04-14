class_name FilterManager
extends Node

# To add a filter:
# 1. Create a Control scene in scenes/objects/filters amd add your filter
# 2. Add it to the filters array
# 3. Done!

signal filter_changed

var _index : int
var _current_filter : Control

@export var filters: Array[PackedScene]

var _original_parent : Node

static var instance : FilterManager

func _ready() -> void:
	_original_parent = get_parent()
	_index = 0
	set_filter(_index)
	ReplayManager.playback_camera_created.connect(_on_replay_manager_playback_camera_created)
	instance = self
	
func _on_replay_manager_playback_camera_created(viewport : SubViewport) -> void:
	reparent(viewport)


func _input(event: InputEvent) -> void:
	if not ReplayManager.is_playing_back():
		if event.is_action_pressed("previous_filter"):
			previous_filter()
			
		if event.is_action_pressed("next_filter"):
			next_filter()

func previous_filter() -> void:
	_index -= 1
	if _index < 0:
		_index = filters.size() - 1
	set_filter(_index)

func next_filter() -> void:
	_index += 1
	if _index > filters.size() - 1:
		_index = 0
	set_filter(_index)

func set_filter(index : int) -> void:
	if _current_filter != null:
		remove_child(_current_filter)
	_current_filter = filters[index].instantiate()
	_current_filter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_current_filter)
	filter_changed.emit()

func _save_state() -> Dictionary:
	var state = {}
	state.index = _index
	return state
	
func _load_state(state : Dictionary) -> void:
	_index = state.index
	set_filter(_index)
