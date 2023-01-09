extends Node3D

const NEEDLE := preload("res://Scenes/needle.tscn")

func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	tween.tween_property(self,"position",position+Vector3.UP*0.5,1.0)
	tween.tween_property(self,"position",position+Vector3.DOWN*0.5,1.0)

func _on_timer_timeout() -> void:
	var needle = NEEDLE.instantiate()
	get_tree().current_scene.add_child(needle)
	needle.global_transform = global_transform
	rotate_y(0.0872665)
