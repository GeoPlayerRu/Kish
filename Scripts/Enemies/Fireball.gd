extends Area3D

const SPEED = 15

@onready var animator := $Animator

func _physics_process(delta: float) -> void:
	global_position -= transform.basis.z * delta * SPEED

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.deal_damage(1.5)
		animator.play("Death")


func _on_death_timer_timeout() -> void:
	animator.play("Death")
