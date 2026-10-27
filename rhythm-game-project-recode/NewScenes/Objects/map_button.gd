extends Button

func _on_pressed() -> void:
	get_tree().current_scene.on_map_button_press(self)
