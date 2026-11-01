extends Button

func _on_pressed() -> void:
	modulate = Color.PURPLE
	get_tree().current_scene.on_map_button_press(self)

func clear_colour() -> void:
	modulate = Color.WHITE
