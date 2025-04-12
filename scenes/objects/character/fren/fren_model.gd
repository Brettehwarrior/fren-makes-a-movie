extends Node3D

@export var fren : Fren
@export var animation_player : AnimationPlayer
@export var open_mouth_mic_threshold : float = 0.5
@export var normal_texture : Texture2D
@export var speaking_texture : Texture2D
@export var front_sprite_top : MeshInstance3D


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
	state.is_speaking = front_sprite_top.get_active_material(0).albedo_texture == speaking_texture
	return state


func _load_state(state : Dictionary) -> void:
	if state.is_speaking:
		if front_sprite_top.get_active_material(0).albedo_texture == normal_texture:
			front_sprite_top.get_active_material(0).albedo_texture = speaking_texture
	else:
		if front_sprite_top.get_active_material(0).albedo_texture == speaking_texture:
			front_sprite_top.get_active_material(0).albedo_texture = normal_texture


func _process(_delta: float) -> void:
	if ReplayManager.is_playing_back():
		return
	
	var mesh_material = front_sprite_top.get_active_material(0)
	mesh_material.albedo_texture = normal_texture
	var mic_volume : float = MicrophoneManager.get_current_mic_volume()
	if mic_volume >= open_mouth_mic_threshold:
		if mesh_material.albedo_texture == normal_texture:
			mesh_material.albedo_texture = speaking_texture
	else:
		if mesh_material.albedo_texture == speaking_texture:
			mesh_material.albedo_texture = normal_texture
