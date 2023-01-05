extends Area3D

class_name Enemy

const FIREWOOD := preload("res://Scenes/firewood.tscn")

@export var speed := 2.5
var speed_mult := 1.0

@export var max_hp : int
var hp : int

@export var damage : float

@onready var attack_cooldown := $AttackCooldown
@onready var agent := $NavigationAgent3D

signal on_death()

var direction : Vector3

func _ready() -> void:
	hp = max_hp
	WaveSystem.enemies+=1

func deal_damage(dmg : int):
	hp -= dmg
	if hp <= 0:
		var firewood = FIREWOOD.instantiate()
		get_parent().add_child(firewood)
		firewood.global_position = global_position + Vector3.UP*0.1
		Globals.player.on_enemy_death()
		WaveSystem.enemies-=1
		queue_free()

func _physics_process(delta: float) -> void:
	direction = global_position.direction_to(agent.get_next_location())
	global_position += direction * speed * delta * speed_mult
	
	if Globals.player != null:
		agent.target_location = Globals.player.global_position

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.deal_damage(damage)
		attack_cooldown.start()


func _on_attack_cooldown_timeout() -> void:
	Globals.player.deal_damage(damage)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		attack_cooldown.stop()
