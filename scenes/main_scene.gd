class_name MainScene
extends Node

static var instance : MainScene

@export var _initial_world : PackedScene

@onready var _world_root_node : Node3D = $World

func _ready() -> void:
	instance = self
	_set_world(_initial_world)


func _set_world(world_scene : PackedScene) -> void:
	var world_node = world_scene.instantiate()
	_world_root_node.add_child(world_node)


static func set_world(world_scene : PackedScene) -> void:
	instance._set_world(world_scene)
