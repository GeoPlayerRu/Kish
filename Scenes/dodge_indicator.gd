extends Panel

@export var timer : Timer
@onready var color := $ColorRect

func _process(_delta: float) -> void:
	color.size.y = 100 * timer.time_left/timer.wait_time
