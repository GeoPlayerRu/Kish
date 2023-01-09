extends Area3D

@export var multiplier := 1.0

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.velocity.y = 15 * multiplier
		if body is Player:
			body.deal_damage(multiplier)
	if body is Enemy:
		body.deal_damage(multiplier)
