class_name MainScene
extends Node

signal loaded_menu
signal loaded_level


static var instance : MainScene

@export var initial_world : PackedScene
@export var story_world : PackedScene
@export var main_level_world_uid : String
static var main_level_world : PackedScene

@export var loading_screen_root : Control
@export var loading_progress_bar : ProgressBar

@onready var _world_root_node : Node3D = $World

func _ready() -> void:
	instance = self
	_set_world(initial_world)
	_load_main_level_world(main_level_world_uid)
	loading_screen_root.visible = false


# func _process(_delta: float) -> void:
# 	if not loading_screen_root.visible:
# 		return
	
# 	var progress = []
# 	var load_status = ResourceLoader.load_threaded_get_status(main_level_world_uid, progress)
# 	print(progress[0])
# 	if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
# 		loading_progress_bar.value = progress[0] * 100
# 	elif load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
# 		loading_screen_root.visible = false


func _set_world(world_scene : PackedScene) -> void:
	_clear_world_scene()
	var world_node = world_scene.instantiate()
	_world_root_node.add_child(world_node)


func _load_main_level_world(uid : String) -> void:
	ResourceLoader.load_threaded_request(uid)


func _clear_world_scene() -> void:
	for child in _world_root_node.get_children():
		child.queue_free()


static func load_world(world_scene : PackedScene) -> void:
	instance._set_world(world_scene)


static func load_main_level_world() -> void:
	# instance.loading_screen_root.visible = true
	if main_level_world == null:
		main_level_world = ResourceLoader.load_threaded_get(instance.main_level_world_uid)
	instance._set_world(instance.main_level_world)
	instance.loaded_level.emit()


static func load_story_world() -> void:
	instance._set_world(instance.story_world)


static func load_initial_world() -> void:
	instance._set_world(instance.initial_world)
	instance.loaded_menu.emit()
