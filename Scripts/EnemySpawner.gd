extends Node3D

var querry : Array[PackedScene]
var started : bool = false

func queue(scene : PackedScene):
	querry.append(scene)

func _on_timer_timeout() -> void:
	if querry.size() > 0:
		var spawned = querry.pop_back().instantiate()
		
		get_parent().add_child(spawned)
		spawned.global_position = global_position
