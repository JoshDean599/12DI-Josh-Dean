extends Node2D

@export var SongList : VBoxContainer
var SongButton = preload("res://Scenes/Objects/song_button.tscn")
var SelectedSong = null

func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		refresh_song_list()

func refresh_song_list() -> void:
	clear_song_list()
	load_song_list()

func clear_song_list() -> void:
	for child in SongList.get_children():
		child.free()

func add_song_button(Name) -> void:
	var newButton = SongButton.instantiate()
	newButton.text = Name
	SongList.add_child.call_deferred(newButton)

func load_song_list() -> void:
	var songs = get_parent().get_file_list(get_parent().SongMapDirPath)
	for song in songs:
		add_song_button(song)
	
	SongButtonSelected(songs[0]) # Select the first song.

func SongButtonSelected(song) -> void:
	SelectedSong = song
	var songContents = get_tree().current_scene.get_file_list(get_parent().SongMapDirPath + "/" + song)
	# Seperate into seperate difficulty folders later
	for map in songContents:
		
		pass

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(get_parent().SongMapDirPath)


# Delete file from the system
# OS.move_to_trash(ProjectSettings.globalize_path(get_tree().current_scene.SongMapDirPath + "/" + song.text))
