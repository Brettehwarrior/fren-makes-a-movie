class_name ReplayableCharacter
extends CharacterBody3D

signal started_walking
signal stopped_walking
var _is_walking : bool = false
var _was_walking_last_check : bool = false

@export var input : PlayerInput
@export var walk_acceleration : float
@export var max_walk_speed : float
@export_range(0, 1) var walk_friction : float
@export var rigid_body_push_force : float


func _save_state() -> Dictionary:
	var state : Dictionary = {}
	state.position = position
	state.rotation = rotation
	state.velocity = velocity
	return state


func _load_state(state : Dictionary) -> void:
	position = state.position
	rotation = state.rotation
	velocity = state.velocity


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

	horizontal_velocity = Vector2(velocity.x, velocity.z)
	_is_walking = horizontal_velocity.length() > 0 and horizontal_input.length() > 0
	if _is_walking and not _was_walking_last_check:
		started_walking.emit()
	elif not _is_walking and _was_walking_last_check:
		stopped_walking.emit()
	_was_walking_last_check = _is_walking


func _push_rigid_bodies() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody3D:
			var push_amount = -collision.get_normal() * rigid_body_push_force
			collider.apply_central_impulse(-collision.get_normal() * rigid_body_push_force)
			if input.get_horizontal_input().length() > 0:
				velocity += Vector3(push_amount.x, 0, push_amount.z)
