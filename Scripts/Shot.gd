extends RayCast3D

class_name Shot

@export var damage := 10.0
@export var damage_mult := 1.0

@onready var line : MeshInstance3D= $Line

var on_hit : Callable

func _ready() -> void:
	var distance = global_position.distance_to(get_collision_point())
	line.position.z = distance/2.0/0.05
	line.mesh.height = distance/0.05
	await get_tree().process_frame
	get_tree().create_timer(0.2,true).timeout.connect(hide_ray)
	
	var collider = get_collider()
	if collider is Enemy:
		collider.deal_damage(damage * damage_mult)
	
	on_hit.call(get_collision_point())


func hide_ray():
	queue_free()
