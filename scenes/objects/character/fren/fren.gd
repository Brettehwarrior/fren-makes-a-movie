extends CharacterBody3D

@export var input : PlayerInput
@export var camcorder_hold_position : Node3D
@export var camera_pivot : Node3D
@export var camera : Node3D
@export var walk_acceleration : float
@export var max_walk_speed : float
@export_range(0, 1) var walk_friction : float
@export var rigid_body_push_force : float

# TODO: Get Camcorder in smarter way
@export var camcorder : Camcorder

var _velocity : Vector3

func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = position
	state.rotation = rotation
	state.velocity = _velocity
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	rotation = state.rotation
	_velocity = state.velocity
	pass


func _process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		return
	
	_process_camera_rotation(delta)
	
	if input.is_camera_drop_button_just_presed():
		if camcorder.is_held():
			camcorder.reset_follow_nodes()
		else:
			camcorder.set_follow_position_node(camcorder_hold_position)
			camcorder.set_follow_rotation_node(camera)


func _process_camera_rotation (delta : float) -> void:
	var look_input : Vector2 = input.get_look_input()
	rotate_y(-look_input.x * delta)
	camera_pivot.rotation.y = rotation.y
	camera.rotate_x(-look_input.y * delta)
	camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta: float) -> void:
	if ReplayManager.is_playing_back():
		return

	_process_horizontal_velocity(delta)
	move_and_slide()
	_push_rigid_bodies()

func _process_horizontal_velocity(delta : float) -> void:
	
	var horizontal_input = input.get_horizontal_input()
	var movement_vector = Vector3(horizontal_input.x, 0, horizontal_input.y)
	var horizontal_acceleration = walk_acceleration * movement_vector * delta
	horizontal_acceleration = horizontal_acceleration.rotated(Vector3.UP, -rotation.y)
	velocity.x += horizontal_acceleration.x * delta
	velocity.z -= horizontal_acceleration.z * delta

	var horizontal_velocity : Vector2 = Vector2(velocity.x, velocity.z)
	if horizontal_velocity.length() > max_walk_speed:
		var change_vector = -horizontal_velocity.normalized() * walk_acceleration
		velocity.x -= change_vector.x
		velocity.z -= change_vector.y

	velocity.x *= walk_friction
	velocity.z *= walk_friction


func _push_rigid_bodies() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody3D:
			var push_amount = -collision.get_normal() * rigid_body_push_force
			collider.apply_central_impulse(-collision.get_normal() * rigid_body_push_force)
			if input.get_horizontal_input().length() > 0:
				velocity += Vector3(push_amount.x, 0, push_amount.z)
