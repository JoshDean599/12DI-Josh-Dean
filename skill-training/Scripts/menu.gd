extends Control

func _on_play_pressed() -> void:
	get_parent().change_scene(name, "SongSelectMenu")

func _on_editor_pressed() -> void:
	get_parent().change_scene(name, "Editor")

func _on_quit_pressed() -> void:
	get_tree().quit()
