extends Node2D


func _on_play_pressed() -> void:
	Globals.change_scene(Globals.SongSelectMenu)


func _on_editor_pressed() -> void:
	Globals.change_scene(Globals.Editor)


func _on_quit_pressed() -> void:
	get_tree().quit()
