extends Label

func _ready() -> void:
	WaveSystem.on_waves_changed.connect(set_label)

func set_label(value : int):
	text = ""
	if value < 10:
		text = "0"
	text += str(value)
	text += "/15"
