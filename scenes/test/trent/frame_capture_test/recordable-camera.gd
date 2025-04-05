extends Camera3D

var _is_recording : bool = false
var _current_frame : int = 0

func _ready() -> void:
	_is_recording = true

func _physics_process(_delta: float) -> void:

	if _is_recording:
		_record_frame()

func _record_frame():
	var frame_image = get_viewport().get_texture().get_image()
	DirAccess.make_dir_recursive_absolute("user://recording")
	frame_image.save_jpg("user://recording/frame_%05d.jpg" % _current_frame)
	_current_frame += 1

	if _current_frame >= 200:
		_is_recording = false

func start_recording():
	_is_recording = true

func stop_recording():
	_is_recording = false
