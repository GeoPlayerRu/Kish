extends Area3D

const layout := preload("res://default_bus_layout.tres")

var ambient_bus : int
var filter : int

func _ready() -> void:
	ambient_bus = AudioServer.get_bus_index("Ambient")
	AudioServer.set_bus_layout(layout)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		AudioServer.set_bus_effect_enabled(ambient_bus,1,true)




func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		AudioServer.set_bus_effect_enabled(ambient_bus,1,false)
