class_name Fren
extends ReplayableCharacter

@export var camcorder_hold_position : Node3D
@export var camera_pivot : Node3D
@export var camera : Node3D
@export var model : FrenModel

# TODO: Get Camcorder in smarter way
@export var camcorder : Camcorder

func _ready() -> void:
	assert(camcorder != null, "Camcorder node is not attached to fren! This will break things!!")


func _process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		return
	
	_process_camera_rotation(delta)
	
	if input.is_camera_drop_button_just_presed():
		if camcorder.is_held():
			camcorder.reset_follow_nodes()
		else:
			camcorder.set_follow_position_node(camcorder_hold_position)


func _process_camera_rotation (delta : float) -> void:
	var look_input : Vector2 = input.get_look_input()
	rotate_y(-look_input.x * delta)
	camera_pivot.rotation.y = rotation.y
	camera.rotate_x(-look_input.y * delta)
	camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func start_sitting() -> void:
	model.start_sitting()


func stop_sitting() -> void:
	model.stop_sitting()
