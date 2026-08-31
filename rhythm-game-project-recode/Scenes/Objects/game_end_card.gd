extends Control

func _on_restart_pressed() -> void:
	get_tree().current_scene.change_scene("Game") # Reload the Game scene

func _on_back_pressed() -> void:
	get_tree().current_scene.change_scene("SongSelectMenu") # Switch the scene to the song select menu
