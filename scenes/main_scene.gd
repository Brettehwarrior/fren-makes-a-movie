class_name MainScene
extends Node

static var instance : MainScene

@export var initial_world : PackedScene
@export var main_level_world : PackedScene

@onready var _world_root_node : Node3D = $World

func _ready() -> void:
	instance = self
	_set_world(initial_world)


func _set_world(world_scene : PackedScene) -> void:
	_clear_world_scene()
	var world_node = world_scene.instantiate()
	_world_root_node.add_child(world_node)


func _clear_world_scene() -> void:
	for child in _world_root_node.get_children():
		child.queue_free()


static func load_world(world_scene : PackedScene) -> void:
	instance._set_world(world_scene)


static func load_main_level_world() -> void:
	instance._set_world(instance.main_level_world)
