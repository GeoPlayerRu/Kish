extends Interactable
const GIFT_SPAWNER = preload("res://Scenes/present_spawner.tscn")

var began: bool = false

func _use():
	if began or WaveSystem.locked: return
	began = true
	while(Globals.firewoods >= 3):
		Globals.firewoods -= 3
		var spawner = GIFT_SPAWNER.instantiate()
		get_parent().add_child(spawner)
		spawner.position = Vector3.ZERO
		await spawner.on_chosen
	began = false
	WaveSystem.prepare()
