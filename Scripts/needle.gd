extends Area3D

func _physics_process(delta: float) -> void:
	global_translate(transform.basis.z * delta * 10.0)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.deal_damage(0.1)


func _on_timer_timeout() -> void:
	queue_free()
