extends Node2D

@export var SongList : VBoxContainer
@export var DifficultyList : HBoxContainer
@export var CreateNewSongPopup : PanelContainer
@export var CreateNewDifficultyPopup : PanelContainer
@onready var optionButton = CreateNewSongPopup.get_node("PanelContainer/MarginContainer/VBoxContainer/OptionButton")
var SongButton = preload("res://Scenes/Objects/song_button.tscn")
var SelectedSongButton = null
var SelectedDifficultyButton = null

func _ready() -> void:
	CreateNewSongPopup.visible = false
	CreateNewDifficultyPopup.visible = false

func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		refresh_song_list()

func refresh_song_list() -> void:
	# Clear the list
	for child in SongList.get_children():
		child.free()
	# Load the songs into the list
	var songs = get_parent().get_file_list(get_parent().SongMapDirPath)
	var firstSong = null
	for song in songs:
		var newButton = SongButton.instantiate()
		newButton.text = song
		SongList.add_child(newButton)
		if song == songs[0]:
			firstSong = newButton
	# Create the add song Button
	var addButton = SongButton.instantiate()
	addButton.text = "+"
	SongList.add_child(addButton)
	
	if typeof(SelectedSongButton) == TYPE_STRING:
		SongSelected(SelectedSongButton)
	elif firstSong:
		SongSelected(firstSong)

func SongSelected(song) -> void:
	if typeof(song) == TYPE_STRING:
		for Song in SongList.get_children():
			if Song.text == song:
				Song.select()
				SelectedSongButton = Song
				break
	else:
		SelectedSongButton = song
		song.select()
		song = song.text
	var songContents = get_tree().current_scene.get_file_list(get_parent().SongMapDirPath + "/" + song + "/difficulties")
	# Clear the difficulty list
	for child in DifficultyList.get_children():
		child.free()
	# Seperate into seperate difficulty folders later
	if len(songContents) == 0:
		if SelectedDifficultyButton:
			SelectedDifficultyButton.deselect()
			SelectedDifficultyButton = null
	else:
		for map in songContents:
			var newButton = SongButton.instantiate()
			newButton.isSongButton = false
			newButton.text = get_parent().remove_file_name_type(map, ".json")
			DifficultyList.add_child.call_deferred(newButton)
			if map == songContents[0]:
				SelectedDifficultyButton = newButton
				SelectedDifficultyButton.text = map
				newButton.select()
	# Create the add difficulty Button
	var addButton = SongButton.instantiate()
	addButton.isSongButton = false
	addButton.text = "+"
	DifficultyList.add_child.call_deferred(addButton)

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(get_parent().SongMapDirPath)

func create_new(Type) -> void:
	if Type == "Song":
		CreateNewSongPopup.visible = true
		optionButton.clear()
		for music in get_tree().current_scene.get_file_list(get_parent().SongMusicDirPath): # Load imported songs
			music = get_tree().current_scene.remove_file_name_type(music, ".mp3")
			if music == "": continue # Make sure the file was an mp3
			optionButton.get_popup().add_item(music)
		for music in get_tree().current_scene.get_file_list("res://Assets/Songs/"): # Load built-in songs
			music = get_tree().current_scene.remove_file_name_type(music, ".mp3")
			if music == "": continue # Make sure the file was an mp3
			optionButton.get_popup().add_item(music)
		if optionButton.get_popup().item_count > 0:
			optionButton.select(0)
	elif Type == "Difficulty":
		CreateNewDifficultyPopup.visible = true

# Delete file from the system -- use in the editor somewhere
# OS.move_to_trash(ProjectSettings.globalize_path(get_tree().current_scene.SongMapDirPath + "/" + song.text))

# Add case detection for duplicate songs <-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!



func _on_song_cancel_pressed() -> void:
	CreateNewSongPopup.visible = false

func _on_difficulty_cancel_pressed() -> void:
	CreateNewDifficultyPopup.visible = false

func _on_open_song_folder_pressed() -> void: # For custom songs
	OS.shell_open(get_parent().SongMusicDirPath)

func _on_create_map_pressed() -> void:
	var dir = DirAccess.open(get_parent().SongMapDirPath)
	var mapName = $CanvasLayer/CreateNewSong/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	var extra = 1
	if dir.dir_exists(mapName): # If the map already exists:
		while dir.dir_exists(mapName + str(extra)): # Add an extra number to make sure the name is unique.
			extra += 1
		mapName += str(extra)
	if dir.make_dir_recursive(mapName + "/difficulties"): # Throw an error if the directory was unable to be created
		print("Unable to create directory.")
		return
	SelectedSongButton.deselect()
	SelectedSongButton = mapName
	refresh_song_list()
	CreateNewSongPopup.visible = false
	# Create a song Properties json file
	var file = FileAccess.open(get_parent().SongMapDirPath + "/" + mapName + "/Properties.json", FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(JSON.stringify({ # The file Contents:
		Song = optionButton.get_item_text(optionButton.get_item_index(optionButton.get_selected_id()))
	}, "\t"))


func _on_create_difficulty_pressed() -> void:
	var difficultyName = $CanvasLayer/CreateNewDifficulty/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	var dir = DirAccess.open(get_parent().SongMapDirPath + "/" + SelectedSongButton.text + "/difficulties")
	var extra = 1
	if dir.file_exists(difficultyName + ".json"): # Make sure the difficultyName is unique
		while dir.file_exists(difficultyName + str(extra) + ".json"):
			extra += 1
		difficultyName += str(extra)
	CreateNewDifficultyPopup.visible = false
	SongSelected(SelectedSongButton)
	var file = FileAccess.open(dir.get_current_dir() + "/" + difficultyName + ".json", FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(JSON.stringify({
			Notes = []
		}, "\t"))
	
	
