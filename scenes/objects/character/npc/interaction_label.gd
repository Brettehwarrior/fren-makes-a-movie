extends Label3D

func _process(_delta: float) -> void:
	# Force sizing to not be affected by parent scale
	var parent_scale = get_parent().scale
	scale = Vector3(1 / parent_scale.x, 1 / parent_scale.y, 1 / parent_scale.z)
