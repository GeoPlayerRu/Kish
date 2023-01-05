extends Area3D

class_name Interactable

signal on_use

@export var locked : bool

func use():
	if locked: return
	_use()
	on_use.emit()

func _use():
	pass
