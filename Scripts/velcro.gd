extends Enemy

const ICE_ATTACK := preload("res://Scenes/icy_attack.tscn")

@onready var pre_attack := $PreAttack
@onready var sprite := $Sprite3D

func _on_ice_attack_cooldown_timeout() -> void:
	speed_mult = 0
	pre_attack.start()


func _on_pre_attack_timeout() -> void:
	speed_mult = 1
	var attack := ICE_ATTACK.instantiate()
	get_parent().add_child(attack)
	attack.global_position = sprite.global_position
	attack.look_at(to_global(-direction))
	
