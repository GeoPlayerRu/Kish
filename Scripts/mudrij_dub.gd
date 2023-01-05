extends Enemy

const FIREBALL = preload("res://Scenes/fireball.tscn")

@onready var prefire_timer := $Prefire
@onready var sound := $Sound

func _physics_process(delta: float) -> void:
	direction = global_position.direction_to(agent.get_next_location())
	global_position += direction * speed * delta * speed_mult
	
	if Globals.player != null:
		agent.target_location = Globals.player.global_position + Globals.player.global_position.direction_to(global_position)*15.0

func _on_prefire_timeout() -> void:
	if Globals.player == null: return
	var fireball := FIREBALL.instantiate()
	get_parent().add_child(fireball)
	sound.play()
	fireball.global_position = $Sprite3D.global_position
	fireball.look_at(Globals.player.global_position)
	speed_mult = 1.0


func _on_fire_timer_timeout() -> void:
	prefire_timer.start()
	speed_mult = 0.0
