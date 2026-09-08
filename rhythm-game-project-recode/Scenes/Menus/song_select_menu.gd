extends Node2D

@onready var songList = $MarginContainer/VBoxContainer/FileList

func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		songList.refresh_list()
