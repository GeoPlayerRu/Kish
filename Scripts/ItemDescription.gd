extends Node

class_name ItemDescription

@onready var timer := $Timer
@onready var label := $Panel/Margin/Text
@onready var animation := $AnimationPlayer

var items_to_show : Array[String]
var started : bool = false

func _ready() -> void:
	Globals.item_description = self

func queue(item : String):
	items_to_show.append(item)
	if !started:
		describe()
		started = true

func describe():
	timer.start()
	animation.play("Show")
	while(items_to_show.size() > 0):
		label.text = tr(items_to_show.pop_front())
		create_tween().tween_property(label,"modulate",Color.WHITE,1.0)
		await timer.timeout
		var tween = create_tween()
		tween.tween_property(label,"modulate",Color.TRANSPARENT,1.0)
		await tween.step_finished
	timer.stop()
	animation.play("Hide")
	started = false
