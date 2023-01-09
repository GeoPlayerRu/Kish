extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.start_morozing()


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.stop_morozing()
