class_name Fren
extends ReplayableCharacter

@export var camcorder_hold_position : Node3D
@export var camera_pivot : Node3D
@export var camera : Node3D
@export var model : FrenModel

# TODO: Get Camcorder in smarter way
@export var camcorder : Camcorder

func _ready() -> void:
	super()
	
	assert(camcorder != null, "Camcorder node is not attached to fren! This will break things!!")
	EventBus.global_fren_reference = self
	
	await get_tree().create_timer(0.5).timeout
	camcorder.set_follow_position_node(camcorder_hold_position)
	


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


func _input(event: InputEvent) -> void:
	# DEBUG STUFF
	if SettingsManager.debug_enabled:
		if event.is_action_pressed("debug_reset_position"):
			_reset_position()
		
		if event.is_action_pressed("debug_teleport_oob"):
			position.y = -50
			
		if event.is_action_pressed("debug_teleport_roof"):
			_reset_position()
			position.y = 12
