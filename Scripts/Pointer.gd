extends RayCast3D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		if is_colliding():
			var collider = get_collider()
			if collider is Interactable:
				collider.use()

