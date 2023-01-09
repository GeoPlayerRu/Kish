extends Node3D

var gravity : float = 0.0
var speed : float

func _ready() -> void:
	get_tree().create_timer(1.0).timeout.connect(queue_free)
	speed = randf_range(1,2)
	

func _process(delta: float) -> void:
	global_position += Vector3(0,1 - gravity,-1) * speed * delta
	gravity += 9.8 * delta
