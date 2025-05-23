extends CanvasLayer

func _ready() -> void:
	FilterManager.instance.filter_changed.connect(_on_filter_changed)
	_on_filter_changed()
	
func _on_filter_changed():
	if get_children().size() > 0:
		get_child(0).queue_free()
		
	add_child(FilterManager.instance._current_filter.duplicate())
