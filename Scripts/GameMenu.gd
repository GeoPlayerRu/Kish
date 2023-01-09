extends Control

@onready var screen_effects := $"../ScreenEffects"


var toggled : bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		toggled = !toggled
		get_tree().paused = toggled
		visible = toggled
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if toggled else Input.MOUSE_MODE_CAPTURED
		$Panel/MarginContainer/VBoxContainer/SensivitySlider.grab_focus()


func _on_sensivity_value_changed(value: float) -> void:
	Globals.player.sensivity = value


func _on_gamepad_sensivity_slider_value_changed(value: float) -> void:
	Globals.player.gamepad_sensivity = value


func _on_check_box_toggled(button_pressed: bool) -> void:
	screen_effects.visible = button_pressed


func _on_pixelization_value_changed(value: float) -> void:
	screen_effects.material.set_shader_parameter("amount",value)



func _on_color_correction_value_changed(value: float) -> void:
	screen_effects.material.set_shader_parameter("colors_count",value)


func _on_pixelization_check_toggled(button_pressed: bool) -> void:
	screen_effects.material.set_shader_parameter("pixelization_enabled",button_pressed)


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value*0.56-50)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"),value*0.26-20)
