extends Enemy

@export var devation : float

func _physics_process(delta: float) -> void:
	var direction_to_player = global_position.direction_to(agent.get_next_location())
	var direction_deviation = Vector3(cos(devation * 0.785398),0,sin(devation * 0.785398))
	direction = (direction_to_player * direction_deviation + direction_to_player).normalized()
	global_position += direction * speed * delta * speed_mult
	
	if Globals.player != null:
		agent.target_location = Globals.player.global_position
