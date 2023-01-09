extends Area3D

const EXPLOSION := preload("res://Scenes/explosion.tscn")
const SPEED := 100

var damage : float

func _physics_process(delta: float) -> void:
	global_position += transform.basis.z * delta * SPEED


func _on_area_entered(area: Area3D) -> void:
	if area is Enemy:
		area.deal_damage(damage/2.0)
		var explosion = EXPLOSION.instantiate()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = global_position
		explosion.radius = damage/4.0
		explosion.damage = damage
		queue_free()
