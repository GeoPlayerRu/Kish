extends RigidBody3D


func _on_fade_out_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	ItemBank.restart()
