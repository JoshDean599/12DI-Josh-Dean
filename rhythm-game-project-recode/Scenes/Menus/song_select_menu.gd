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

func refresh_from_file(loadPath: String, destination: Container, songButton: bool) -> void:
	for child in destination.get_children():
		child.free()
	if loadPath == "":
		return
	var loaded = get_parent().get_file_list(loadPath)
	if not loaded:
		return
	if len(loaded) == 0:
		if songButton:
			SelectedSongButton = null
		else:
			SelectedDifficultyButton = null
	
	for item in loaded:
		var newButton = SongButton.instantiate()
		newButton.text = get_parent().remove_file_name_type(item, ".json")
		if newButton.text == "":
			newButton.text = item
		newButton.isSongButton = songButton
		destination.add_child(newButton)
		if typeof(SelectedSongButton) == TYPE_STRING and item == SelectedSongButton:
			newButton.select()
			SelectedSongButton = newButton
	
	if typeof(SelectedSongButton) == TYPE_STRING:
		destination.get_child(0).select()
		SelectedSongButton = destination.get_child(0)
	
	var addButton = SongButton.instantiate()
	addButton.text = "+"
	addButton.isSongButton = songButton
	destination.add_child(addButton)

func refresh_song_list() -> void:
	if SelectedSongButton:
		SelectedSongButton = SelectedSongButton.text
	refresh_from_file(get_parent().SongMapDirPath, SongList, true)
	
	#if SelectedSongButton:
	#	SongSelected(SelectedSongButton)
	#elif SongList.get_child(0):
	#	if SongList.get_child(0).text == "+":
	#		SongSelected(null)
	#	else:
	#		SongSelected(SongList.get_child(0))

#func SongSelected(song) -> void:
	#if song == null:
		#refresh_from_file("", DifficultyList, false)
	##---
	#if typeof(song) == TYPE_STRING:
		#for Song in SongList.get_children():
			#if Song.text == song:
				#Song.select()
				#SelectedSongButton = Song
				#break
	#else:
		#SelectedSongButton = song
		#if song == null: return
		#song.select()
		#song = song.text
	##---

func refresh_difficulty_list() -> void:
	refresh_from_file(get_parent().SongMapDirPath + "/" + SelectedSongButton.text + "/difficulties", DifficultyList, false)

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(get_parent().SongMapDirPath)

func add_to_option_button_list_from_path(path: String):
	for music in get_tree().current_scene.get_file_list(path):
		music = get_tree().current_scene.remove_file_name_type(music, ".mp3")
		if music == "": continue # Make sure the file was an mp3
		optionButton.get_popup().add_item(music)

func create_new(Type) -> void:
	if Type == "Song":
		CreateNewSongPopup.visible = true
		optionButton.clear()
		# Add both built in and imported songs to the option button's list
		add_to_option_button_list_from_path(get_parent().SongMusicDirPath)
		add_to_option_button_list_from_path("res://Assets/Songs/")
		if optionButton.get_popup().item_count > 0:
			optionButton.select(0)
	elif Type == "Difficulty":
		CreateNewDifficultyPopup.visible = true

func _on_song_cancel_pressed() -> void:
	CreateNewSongPopup.visible = false

func _on_difficulty_cancel_pressed() -> void:
	CreateNewDifficultyPopup.visible = false

func _on_open_song_folder_pressed() -> void: # For custom songs
	OS.shell_open(get_parent().SongMusicDirPath)

func _on_create_map_pressed() -> void:
	var mapName = $CanvasLayer/CreateNewSong/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	mapName = get_parent().create_folder(get_parent().SongMapDirPath, mapName)
	get_parent().create_folder(get_parent().SongMapDirPath + "/" + mapName, "Difficulties")
	get_parent().create_or_modify_file(get_parent().SongMapDirPath + "/" + mapName, "Properties", {
		song = optionButton.get_item_text(optionButton.get_item_index(optionButton.get_selected_id()))
	})
	
	SelectedSongButton = mapName
	refresh_song_list()
	CreateNewSongPopup.visible = false

func _on_create_difficulty_pressed() -> void:
	var difficultyName = $CanvasLayer/CreateNewDifficulty/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	get_parent().create_or_modify_file(get_parent().SongMapDirPath + "/" + SelectedSongButton.text + "/Difficulties", difficultyName, {
		Notes = []
	})
	refresh_song_list()
	CreateNewDifficultyPopup.visible = false

func _on_delete_map_pressed() -> void:
	if SelectedSongButton == null:
		return
	OS.move_to_trash(ProjectSettings.globalize_path(get_tree().current_scene.SongMapDirPath + "/" + SelectedSongButton.text))
	refresh_song_list()
