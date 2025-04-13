extends MeshInstance3D

@export var holding_camera_texture : Texture2D
@export var remote_camera_off_texture : Texture2D
@export var remote_camera_on_texture : Texture2D

var _is_holding : bool = false


func _set_material_texture(texture : Texture2D) -> void:
	get_active_material(0).albedo_texture = texture


func _ready() -> void:
	ReplayManager.started_playback.connect(_on_replay_manager_started_playback)
	ReplayManager.started_recording.connect(_on_replay_manager_started_recording)
	ReplayManager.stopped_recording.connect(_on_replay_manager_stopped_recording)
	EventBus.camcorder_dropped.connect(_on_camcorder_dropped)
	EventBus.camcorder_picked_up.connect(_on_camcorder_picked_up)


func _on_replay_manager_started_playback() -> void:
	visible = false


func _on_replay_manager_started_recording() -> void:
	if _is_holding:
		return
	_set_material_texture(remote_camera_on_texture)


func _on_replay_manager_stopped_recording() -> void:
	if _is_holding:
		return
	_set_material_texture(remote_camera_off_texture)


func _on_camcorder_dropped() -> void:
	_is_holding = false
	if ReplayManager.is_recording():	
		_set_material_texture(remote_camera_on_texture)
	else:
		_set_material_texture(remote_camera_off_texture)


func _on_camcorder_picked_up() -> void:
	_is_holding = true
	_set_material_texture(holding_camera_texture)
