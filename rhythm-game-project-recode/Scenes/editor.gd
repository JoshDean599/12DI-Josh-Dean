extends Node2D

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")
