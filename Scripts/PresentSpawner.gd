extends Node

signal on_chosen

func choose():
	on_chosen.emit()
	queue_free()
