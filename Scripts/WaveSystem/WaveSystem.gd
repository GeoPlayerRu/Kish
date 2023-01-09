extends Node

var waves : int:
	set(value):
		waves = value
		on_waves_changed.emit(value)
var locked : bool
var door
var started : bool
var wave_spawner
var enemies : int:
	set(value):
		enemies = value
		if enemies <= 0:
			on_enemies_ran_out.emit()
			end()

signal on_enemies_ran_out
signal on_waves_changed(value : int)

func prepare():
	waves += 1
	locked = true
	door.toggle(false)

func start():
	door.toggle(true)
	started = true
	wave_spawner.spawn()

func end():
	locked = false
	started = false
	door.toggle(false)
	Globals.player.max_hp += 0.1
