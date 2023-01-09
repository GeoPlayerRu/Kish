extends Area3D

class_name Interactable

signal on_use

@export var outline_color : Color

@export var locked : bool
@export var outline_material : ShaderMaterial

func use():
	if locked: return
	_use()
	on_use.emit()

func _use():
	pass

func on_begin_point():
	if locked: return
	outline_material.set_shader_parameter("Color",outline_color)

func on_end_point():
	outline_material.set_shader_parameter("Color",Color.TRANSPARENT)
