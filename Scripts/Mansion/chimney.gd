extends Interactable
const GIFT_SPAWNER = preload("res://Scenes/present_spawner.tscn")
const FADE := preload("res://Scenes/fade_out.tscn")


func _use():
	if WaveSystem.waves == 15:
		var fade = FADE.instantiate()
		get_tree().current_scene.add_child(fade)
		await fade.animation_finished
		get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
		return
	if locked or WaveSystem.locked: return
	locked = true
	while(Globals.firewoods >= 3):
		Globals.firewoods -= 3
		var spawner = GIFT_SPAWNER.instantiate()
		get_parent().add_child(spawner)
		spawner.position = Vector3.ZERO
		await spawner.on_chosen
	locked = false
	WaveSystem.prepare()
