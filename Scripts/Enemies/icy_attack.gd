extends Node

const icy_peak := preload("res://Scenes/Enemies/icy_peak.tscn")

var peaks := 8
var count := 0

@onready var raycast := $RayCast3D


func _on_timer_timeout() -> void:
	count+=1
	raycast.position.z += 2.0
	var peak = icy_peak.instantiate()
	get_tree().current_scene.add_child(peak)
	peak.global_position = raycast.get_collision_point()
	if count == peaks:
		queue_free()
