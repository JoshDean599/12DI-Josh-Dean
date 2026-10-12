extends Node2D

@export var SongList : VBoxContainer
@export var DifficultyList : HBoxContainer
@export var CreateNewSongPopup : PanelContainer
@export var CreateNewDifficultyPopup : PanelContainer
var SongButton = preload("res://Scenes/Objects/song_button.tscn")
var SelectedSongButton = null
var SelectedSong = null
var SelectedDifficultyButton = null
var SelectedDifficulty = ""

func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		refresh_song_list()

func refresh_song_list() -> void:
	# Clear the list
	for child in SongList.get_children():
		child.free()
	# Load the songs into the list
	var songs = get_parent().get_file_list(get_parent().SongMapDirPath)
	for song in songs:
		var newButton = SongButton.instantiate()
		newButton.text = song
		SongList.add_child.call_deferred(newButton)
		if song == songs[0]:
			SelectedSongButton = newButton
			newButton.select()
	# Create the add song Button
	var newButton = SongButton.instantiate()
	newButton.text = "+"
	SongList.add_child.call_deferred(newButton)
	SongSelected(songs[0]) # Select the first song.

func SongSelected(song) -> void:
	SelectedSong = song
	
	var songContents = get_tree().current_scene.get_file_list(get_parent().SongMapDirPath + "/" + song)
	# Clear the difficulty list
	for child in DifficultyList.get_children():
		child.free()
	# Seperate into seperate difficulty folders later
	for map in songContents:
		var newButton = SongButton.instantiate()
		newButton.isSongButton = false
		newButton.text = get_parent().remove_file_name_type(map, ".json")
		DifficultyList.add_child.call_deferred(newButton)
		if map == songContents[0]:
			SelectedDifficultyButton = newButton
			SelectedDifficulty = map
			newButton.select()
	# Create the add difficulty Button
	var newButton = SongButton.instantiate()
	newButton.isSongButton = false
	newButton.text = "+"
	DifficultyList.add_child.call_deferred(newButton)

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(get_parent().SongMapDirPath)

func create_new(Type) -> void:
	if Type == "Song":
		CreateNewDifficultyPopup.visible = true
		print("Creating New: Song")
		pass
	elif Type == "Difficulty":
		CreateNewSongPopup.visible = true
		print("Creating New: Difficulty")
		pass
	pass

# Delete file from the system -- use in the editor somewhere
# OS.move_to_trash(ProjectSettings.globalize_path(get_tree().current_scene.SongMapDirPath + "/" + song.text))


func _on_song_cancel_pressed() -> void:
	CreateNewSongPopup.visible = false
	pass # Replace with function body.

func _on_difficulty_cancel_pressed() -> void:
	CreateNewDifficultyPopup.visible = false
	pass # Replace with function body.
