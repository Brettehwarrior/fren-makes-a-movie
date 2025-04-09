@tool

class_name NPCCharacter
extends ReplayableCharacter

@export var npc_resource : NPCResource:
	set(value):
		npc_resource = value
		_apply_resource_values(value)
@export var front_sprite : Sprite3D
@export var back_sprite : Sprite3D
@export var quote_label : Label3D
@export var poke_sound : AudioStream


func _save_state() -> Dictionary:
	var state : Dictionary = super._save_state()
	state.quote_visible = quote_label.visible
	return state


func _load_state(state : Dictionary) -> void:
	super._load_state(state)
	quote_label.visible = state.quote_visible


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_apply_resource_values(npc_resource)
	quote_label.visible = false


func _apply_resource_values(resource : NPCResource) -> void:
	front_sprite.texture = resource.front_texture
	back_sprite.texture = resource.back_texture
	quote_label.text = npc_resource.quote


func _on_interaction_sphere_interaction_triggered() -> void:
	quote_label.visible = true
	AudioManager.play_oneshot(poke_sound, position)
	await get_tree().create_timer(1.0).timeout
	quote_label.visible = false
