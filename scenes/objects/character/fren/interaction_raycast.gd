extends RayCast3D

@export var _target_trigger : Node3D

func _physics_process(delta: float) -> void:
	if is_colliding():
		# Check if there's a new target trigger
		if _target_trigger != get_collider().get_parent():
			# Tell the old target trigger it's been neglected :(
			if _target_trigger != null:
				_target_trigger.on_interaction_range_exited()
			
			# Set the new target trigger
			_target_trigger = get_collider().get_parent()
			
			# Tell the new target trigger it's my new best friend :)
			_target_trigger.on_interaction_range_entered()
		
		# Check for action
		if Input.is_action_just_pressed("interact"):
			_target_trigger.on_interaction_triggered()
	else:
		# Tell the old target trigger it's been neglected :(
		if _target_trigger != null:
			_target_trigger.on_interaction_range_exited()
		
		_target_trigger = null
