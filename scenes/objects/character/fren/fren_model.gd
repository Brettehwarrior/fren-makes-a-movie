class_name FrenModel
extends Node3D

@export var fren : Fren
@export var animation_player : AnimationPlayer
@export var open_mouth_mic_threshold : float = 0.5
@export var normal_texture : Texture2D
@export var speaking_texture : Texture2D
@export var front_sprite_top : MeshInstance3D

@export var sit_pivot : Node3D
@export var sit_angle : float = -90.0
@export var sit_angle_speed : float = 400.0
@export var sit_body_slide_node : Node3D
@export var sit_height : float = 0.1
@export var stand_height : float = -0.378
@export var sit_height_speed : float = 1.2

var _target_sit_height : float = stand_height
var _target_sit_angle : float = 0.0


func _ready() -> void:
	fren.started_walking.connect(_on_fren_started_walking)
	fren.stopped_walking.connect(_on_fren_stopped_walking)
	animation_player.current_animation = "idle"


func _on_fren_started_walking() -> void:
	animation_player.current_animation = "hop"


func _on_fren_stopped_walking() -> void:
	animation_player.current_animation = "idle"


func _save_state() -> Dictionary:
	var state = {}
	state.sit_angle = sit_pivot.rotation.x
	state.stand_height = sit_body_slide_node.position.y
	state.is_speaking = front_sprite_top.get_active_material(0).albedo_texture == speaking_texture
	return state


func _load_state(state : Dictionary) -> void:
	sit_pivot.rotation.x = state.sit_angle
	sit_body_slide_node.position.y = state.stand_height
	if state.is_speaking:
		if front_sprite_top.get_active_material(0).albedo_texture == normal_texture:
			front_sprite_top.get_active_material(0).albedo_texture = speaking_texture
	else:
		if front_sprite_top.get_active_material(0).albedo_texture == speaking_texture:
			front_sprite_top.get_active_material(0).albedo_texture = normal_texture


func _process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		return

	_process_sit(delta)
	
	var mesh_material = front_sprite_top.get_active_material(0)
	mesh_material.albedo_texture = normal_texture
	var mic_volume : float = MicrophoneManager.get_current_mic_volume()
	if mic_volume >= open_mouth_mic_threshold:
		if mesh_material.albedo_texture == normal_texture:
			mesh_material.albedo_texture = speaking_texture
	else:
		if mesh_material.albedo_texture == speaking_texture:
			mesh_material.albedo_texture = normal_texture


func _process_sit(delta) -> void:
	sit_pivot.rotation.x = move_toward(sit_pivot.rotation.x, deg_to_rad(_target_sit_angle), deg_to_rad(sit_angle_speed) * delta)
	sit_body_slide_node.position.y = move_toward(sit_body_slide_node.position.y, _target_sit_height, sit_height_speed * delta)


func start_sitting() -> void:
	_target_sit_angle = sit_angle
	_target_sit_height = sit_height


func stop_sitting() -> void:
	_target_sit_angle = 0
	_target_sit_height = stand_height
