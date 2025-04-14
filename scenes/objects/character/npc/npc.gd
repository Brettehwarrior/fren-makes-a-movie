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
@export var sit_angle_speed : float = 400.0
@export var sit_body_slide_node : Node3D
@export var sit_height : float = 0.0
@export var stand_height : float = -0.378
@export var sit_height_speed : float = 1.2
@export var ghost : bool = false

@export var can_interact : bool = true

var _target_sit_height : float = stand_height
var _target_sit_angle : float = 0.0

var _look_angle_time : float = 0
var _target_look_angle : float

func _save_state() -> Dictionary:
	var state : Dictionary = super._save_state()
	state.quote_visible = quote_label.visible
	state.stand_height = sit_body_slide_node.position.y
	state.sit_angle = sit_pivot.rotation.x
	return state


func _load_state(state : Dictionary) -> void:
	super._load_state(state)
	quote_label.visible = state.quote_visible
	sit_body_slide_node.position.y = state.stand_height
	sit_pivot.rotation.x = state.sit_angle


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_apply_resource_values(npc_resource)
	quote_label.visible = false
	_target_look_angle = rad_to_deg(rotation.y)
	if not can_interact:
		$InteractionSphere.queue_free() # jam code moment
		
	if ghost:
		front_sprite_top.set_layer_mask_value(1, false)
		front_sprite_bottom.set_layer_mask_value(1, false)
		back_sprite_top.set_layer_mask_value(1, false)
		back_sprite_bottom.set_layer_mask_value(1, false)
		
		front_sprite_top.set_layer_mask_value(19, true)
		front_sprite_bottom.set_layer_mask_value(19, true)
		back_sprite_top.set_layer_mask_value(19, true)
		back_sprite_bottom.set_layer_mask_value(19, true)



func _apply_resource_values(resource : NPCResource) -> void:
	if not npc_resource:
		return
	front_sprite_top.get_active_material(0).albedo_texture = resource.front_texture
	front_sprite_bottom.get_active_material(0).albedo_texture = resource.front_texture
	back_sprite_top.get_active_material(0).albedo_texture = resource.back_texture
	back_sprite_bottom.get_active_material(0).albedo_texture = resource.back_texture
	quote_label.text = npc_resource.quote


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_process_sit(delta)
	_process_look_angle(delta)


func _process_sit(delta) -> void:
	sit_pivot.rotation.x = move_toward(sit_pivot.rotation.x, deg_to_rad(_target_sit_angle), deg_to_rad(sit_angle_speed) * delta)
	sit_body_slide_node.position.y = move_toward(sit_body_slide_node.position.y, _target_sit_height, sit_height_speed * delta)


func _process_look_angle(delta : float) -> void:
	_look_angle_time = move_toward(_look_angle_time, 0.2, delta)
	rotation.y = lerp_angle(rotation.y, deg_to_rad(_target_look_angle), _look_angle_time)


func _on_interaction_sphere_interaction_triggered() -> void:
	quote_label.visible = true
	AudioManager.play_oneshot(poke_sound, global_position, 5)

	var h_global_position = Vector2(global_position.x, global_position.z)
	var fren_h_global_position = Vector2(EventBus.global_fren_reference.global_position.x, EventBus.global_fren_reference.global_position.z)

	_target_look_angle = - 90 - rad_to_deg((fren_h_global_position - h_global_position).angle())

	print("new angle = %f" % _target_look_angle)

	_look_angle_time = 0
	await get_tree().create_timer(dialogue_timeout).timeout
	quote_label.visible = false


func start_sitting() -> void:
	_target_sit_angle = sit_angle
	_target_sit_height = sit_height


func stop_sitting() -> void:
	_target_sit_angle = 0
	_target_sit_height = stand_height
