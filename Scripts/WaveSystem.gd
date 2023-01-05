extends Node

var waves : int = 10
var locked : bool
var door : Interactable
var started : bool
var wave_spawner
var enemies : int:
	set(value):
		enemies = value
		if enemies <= 0:
			on_enemies_ran_out.emit()
			end()

var fade := preload("res://Scenes/fade_out.tscn")

signal on_enemies_ran_out

func prepare():
	if waves == 15:
		
		return
	waves += 1
	locked = true
	door.toggle(false)

func start():
	door.toggle(true)
	started = true
	wave_spawner.spawn()

func end():
	if waves == 15:
		var fade_anim = fade.instantiate()
		get_tree().current_scene.add_child(fade_anim)
		await fade_anim.animation_finished
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		return
	locked = false
	started = false
	Globals.player.max_hp += 0.1
