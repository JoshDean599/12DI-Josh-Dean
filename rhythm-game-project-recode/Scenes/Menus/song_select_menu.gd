extends Node2D

@export var SongList : VBoxContainer


func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		add_song_button("Hello World")
		refresh_song_list()

func refresh_song_list() -> void:
	pass

func clear_song_list() -> void:
	pass

func add_song_button(Name) -> void:
	var newButton = Button.new()
	newButton.text = Name
	SongList.add_child.call_deferred(newButton)

func load_song_list() -> void:
	pass

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(get_tree().current_scene.SongMapDirPath)
