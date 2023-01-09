extends RayCast3D

var collider : WeakRef = weakref(null)

func _process(_delta: float) -> void:
	var reference = collider.get_ref()
	if reference != get_collider():
		if reference is Interactable:
			reference.on_end_point()
		collider = weakref(get_collider())
	reference = collider.get_ref()
	if reference:
		if reference is Interactable:
			reference.on_begin_point()
			if Input.is_action_just_pressed("use"):
						reference.use()
	
