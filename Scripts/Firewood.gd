extends Area3D

func _ready() -> void:
	randomize()
	rotate_y(randf_range(0,6.28319))

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.firewoods += 1
		queue_free()
