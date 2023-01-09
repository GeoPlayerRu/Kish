extends Node

@onready var player : Player = $".."
@onready var cooldown := $DodgeCooldown
@onready var dodge_effect := $DodgeTimer

var player_collision_layer : int

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge") and cooldown.time_left == 0:
		player.speed_mult *= 4.0
		dodge_effect.start()
		cooldown.start()
		player_collision_layer = player.collision_layer
		player.collision_layer = 0


func _on_dodge_timer_timeout() -> void:
	player.collision_layer = player_collision_layer
	player.speed_mult /= 4.0
