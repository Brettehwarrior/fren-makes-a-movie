@tool

class_name NPCCharacter
extends ReplayableCharacter

@export var npc_resource : NPCResource:
	set(value):
		npc_resource = value
		_apply_resource_values(value)
@export var front_sprite_top : MeshInstance3D
@export var front_sprite_bottom : MeshInstance3D
@export var back_sprite_top : MeshInstance3D
@export var back_sprite_bottom : MeshInstance3D
@export var quote_label : Label3D
@export var poke_sound : AudioStream
@export var dialogue_timeout : float = 1.0
@export var sit_pivot : Node3D
@export var sit_angle : float = -90.0
@export var sit_angle_speed : float = 270.0
@export var sit_body_slide_node : Node3D
@export var sit_height : float = 0.1
@export var sit_height_speed : float = 0.3

var _target_sit_height : float = 0.0
var _target_sit_angle : float = 0.0

func _save_state() -> Dictionary:
	var state : Dictionary = super._save_state()
	state.quote_visible = quote_label.visible
	state.sit_angle = sit_pivot.rotation.x
	return state


func _load_state(state : Dictionary) -> void:
	super._load_state(state)
	quote_label.visible = state.quote_visible
	sit_pivot.rotation.x = state.sit_angle


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_apply_resource_values(npc_resource)
	quote_label.visible = false


func _apply_resource_values(resource : NPCResource) -> void:
	front_sprite_top.get_active_material(0).albedo_texture = resource.front_texture
	front_sprite_bottom.get_active_material(0).albedo_texture = resource.front_texture
	back_sprite_top.get_active_material(0).albedo_texture = resource.back_texture
	back_sprite_bottom.get_active_material(0).albedo_texture = resource.back_texture
	quote_label.text = npc_resource.quote


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_process_sit(delta)


func _process_sit(delta) -> void:
	sit_pivot.rotation.x = move_toward(sit_pivot.rotation.x, deg_to_rad(_target_sit_angle), deg_to_rad(sit_angle_speed) * delta)
	sit_body_slide_node.position.y = move_toward(sit_body_slide_node.position.y, _target_sit_height, sit_height_speed * delta)


func _on_interaction_sphere_interaction_triggered() -> void:
	quote_label.visible = true
	AudioManager.play_oneshot(poke_sound, position)
	await get_tree().create_timer(dialogue_timeout).timeout
	quote_label.visible = false


func start_sitting() -> void:
	print("i am starting to sit now")
	_target_sit_angle = sit_angle
	_target_sit_height = sit_height

func stop_sitting() -> void:
	print("i am stopping to sit now")
	_target_sit_angle = 0
	_target_sit_height = 0
