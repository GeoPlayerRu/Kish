extends Node3D

var opened
var tween : Tween

func _ready() -> void:
	WaveSystem.door = self

func _use():
	if WaveSystem.locked:
		return
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"rotation_degrees",Vector3.ZERO if opened else Vector3(0,-90,0),0.5)
	opened = !opened

func toggle(state : bool):
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	opened = state
	tween.tween_property(self,"rotation_degrees",Vector3.ZERO if opened else Vector3(0,-90,0),1.0)
	
