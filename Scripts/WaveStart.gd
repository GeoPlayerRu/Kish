extends Node


func _on_body_entered(body: Node3D) -> void:
	if body is Player and !WaveSystem.started and WaveSystem.locked:
		WaveSystem.start()
