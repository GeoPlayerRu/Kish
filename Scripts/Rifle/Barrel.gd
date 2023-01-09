extends Marker3D

class_name Barrel

@export var spread :int
@export var damage_mult : float = 1.0

@export var projectile : PackedScene

@onready var sound := $Audio

var on_hit : Callable

var accuracy : float

func _ready() -> void:
	randomize()

func shoot(damage : float):
	var proj = projectile.instantiate()
	sound.play()
	get_tree().current_scene.add_child(proj)
	proj.damage = damage * damage_mult
	proj.global_transform = global_transform
	proj.rotation_degrees += Vector3(randf_range(-spread*accuracy,spread*accuracy),randf_range(-spread*accuracy,spread*accuracy),0)
	if on_hit != null and proj is Shot:
		proj.on_hit = on_hit
		

func set_data(data : BarrelData):
	spread = data.spread
