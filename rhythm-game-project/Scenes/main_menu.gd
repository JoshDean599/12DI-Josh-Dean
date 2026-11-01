extends Node2D

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/song_select.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
