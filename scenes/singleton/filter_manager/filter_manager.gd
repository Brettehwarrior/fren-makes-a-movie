extends Node

# To add a filter:
# 1. Create a Control scene in scenes/objects/filters amd add your filter
# 2. Add it to the filters array
# 3. Done!

signal filter_changed

var _index : int
var _current_filter : Control

@export var filters: Array[PackedScene]

func _ready() -> void:
	_index = 0
	set_filter(_index)
	
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
	_current_filter = filters[_index].instantiate()
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
