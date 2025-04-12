extends ReplayableRigidBody3D


func _on_interaction_cube_interaction_triggered() -> void:
	EventBus.physics_object_interacted_with.emit(self)
