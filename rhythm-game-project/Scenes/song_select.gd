extends Node2D

@export var MapList: VBoxContainer
@export var DifficultyList: HBoxContainer
@onready var SongList = $CanvasLayer/CreateNewMap/PanelContainer/MarginContainer/VBoxContainer/OptionButton
@onready var MapButton = preload("res://Scenes/Objects/map_button.tscn")
@onready var DifficultyButton = preload("res://Scenes/Objects/difficulty_button.tscn")

var selectedMapButton = null
var selectedDifficultyButton = null

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_open_map_folder_pressed() -> void:
	OS.shell_open(FileHandler.SongFolderPath)

func _ready() -> void:
	# Make sure everything is visible that is meant to
	$CanvasLayer/SongSelect.visible = true
	$CanvasLayer/CreateNewMap.visible = false
	$CanvasLayer/CreateNewDifficulty.visible = false
	$CanvasLayer/MapDeleteWarning.visible = false
	$CanvasLayer/DifficultyDeleteWarning.visible = false
	refresh_file_list()

func refresh_file_list():
	for i in MapList.get_children(): # Clear the list if there is anything in it
		i.free()
	for i in FileHandler.get_files_in_path("res://Assets/Maps/"): # -- Built in maps...
		var newButton = MapButton.instantiate()
		newButton.text = i
		MapList.add_child(newButton)
	for i in FileHandler.get_files_in_path(FileHandler.SongFolderPath):
		var newButton = MapButton.instantiate()
		newButton.text = i
		MapList.add_child(newButton)
	if len(MapList.get_children()) > 0:
		if GameData.SelectedMap:
			for i in MapList.get_children():
				if i.text == GameData.SelectedMap:
					selectedMapButton = i
					selectedMapButton.modulate = Color.PURPLE
		else:
			selectedMapButton = MapList.get_child(0)
			selectedMapButton.modulate = Color.PURPLE
			GameData.SelectedMap = selectedMapButton.text
		refresh_difficulty_list()

func refresh_difficulty_list():
	for i in DifficultyList.get_children(): # Clear the list if there is anything in it
		i.free()
	if not GameData.SelectedMap: # If no map was selected, return
		return
	GameData.SelectedDifficulty = null
	for i in FileHandler.get_files_in_path("res://Assets/Maps/" + GameData.SelectedMap + "/Difficulties"):
		var newButton = DifficultyButton.instantiate()
		newButton.text = FileHandler.remove_type(i, ".json")
		DifficultyList.add_child(newButton)
	for i in FileHandler.get_files_in_path(FileHandler.SongFolderPath + "/" +
		GameData.SelectedMap + "/Difficulties"):
		var newButton = DifficultyButton.instantiate()
		newButton.text = FileHandler.remove_type(i, ".json")
		DifficultyList.add_child(newButton)
	if len(DifficultyList.get_children()) > 0:
		selectedDifficultyButton = DifficultyList.get_child(0)
		selectedDifficultyButton.modulate = Color.PURPLE
		GameData.SelectedDifficulty = selectedDifficultyButton.text

func on_map_button_press(button):
	if selectedMapButton != button:
		selectedMapButton.clear_colour()
	selectedMapButton = button
	GameData.SelectedMap = button.text
	refresh_difficulty_list()
	print(button.text, " Pressed")

func on_difficulty_button_press(button):
	if selectedDifficultyButton != button:
		selectedDifficultyButton.clear_colour()
	selectedDifficultyButton = button
	GameData.SelectedDifficulty = button.text
	print(button.text, " Pressed")

# Create New Map:
func add_to_option_button_list_from_path(path: String):
	for music in FileHandler.get_files_in_path(path):
		music = FileHandler.remove_type(music, ".mp3")
		if music == "": continue # Make sure the file was an mp3
		SongList.get_popup().add_item(music)

func _on_add_map_button_pressed() -> void:
	$CanvasLayer/CreateNewMap.visible = true
	SongList.clear()
	# Add both built in and imported songs to the option button's list
	add_to_option_button_list_from_path("res://Assets/Songs/")
	add_to_option_button_list_from_path(FileHandler.MusicFolderPath)
	if SongList.get_popup().item_count > 0:
		SongList.select(0)

func _on_create_map_pressed() -> void:
	var mapName = FileHandler.create_folder(FileHandler.SongFolderPath + "/" +
		$CanvasLayer/CreateNewMap/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text)
	FileHandler.create_folder(mapName[0] + "/" + mapName[1] + "/" + "Difficulties")
	FileHandler.clone_song(SongList.get_item_text(SongList.get_item_index(SongList.get_selected_id())),
		mapName[0] + "/" + mapName[1])
	$CanvasLayer/CreateNewMap.visible = false
	$CanvasLayer/CreateNewMap/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text = ""
	refresh_file_list()
	GameData.SelectedMap = mapName[1]

func _on_map_delete_button_pressed() -> void:
	if GameData.SelectedMap == null:
		return
	OS.move_to_trash(ProjectSettings.globalize_path(FileHandler.SongFolderPath + "/" + GameData.SelectedMap))
	GameData.SelectedMap = null
	refresh_file_list()
	refresh_difficulty_list()
	$CanvasLayer/MapDeleteWarning.visible = false

func _on_cancel_create_map_pressed() -> void:
	$CanvasLayer/CreateNewMap.visible = false
	$CanvasLayer/CreateNewMap/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text = ""

func _on_delete_map_button_pressed() -> void:
	$CanvasLayer/MapDeleteWarning.visible = true

func _on_map_delete_cancel_button_pressed() -> void:
	$CanvasLayer/MapDeleteWarning.visible = false

# Create New Difficulty:
func _on_add_difficulty_button_pressed() -> void:
	$CanvasLayer/CreateNewDifficulty.visible = true

func _on_delete_difficulty_button_pressed() -> void:
	$CanvasLayer/DifficultyDeleteWarning.visible = true

func _on_cancel_create_difficulty_pressed() -> void:
	$CanvasLayer/CreateNewDifficulty.visible = false
	$CanvasLayer/CreateNewDifficulty/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text = ""

func _on_create_difficulty_pressed() -> void:
	if not GameData.SelectedMap:
		return
	var difficultyName = $CanvasLayer/CreateNewDifficulty/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text
	FileHandler.create_file(FileHandler.SongFolderPath + "/" + GameData.SelectedMap + "/Difficulties/" + difficultyName + ".json", {
		Notes = [],
		bufferTime = 0.0
	})
	refresh_difficulty_list()
	$CanvasLayer/CreateNewDifficulty/PanelContainer/MarginContainer/VBoxContainer/LineEdit.text = ""
	$CanvasLayer/CreateNewDifficulty.visible = false

func _on_difficulty_delete_cancel_button_pressed() -> void:
	$CanvasLayer/DifficultyDeleteWarning.visible = false

func _on_difficulty_delete_button_pressed() -> void:
	if not GameData.SelectedMap or not GameData.SelectedDifficulty:
		return
	print("Deleting: ", GameData.SelectedMap, " ", GameData.SelectedDifficulty)
	OS.move_to_trash(ProjectSettings.globalize_path(FileHandler.SongFolderPath + "/" + GameData.SelectedMap + "/Difficulties/" + GameData.SelectedDifficulty + ".json"))
	GameData.SelectedDifficulty = null
	refresh_difficulty_list()
	$CanvasLayer/DifficultyDeleteWarning.visible = false

# Gameplay access:
func _on_edit_pressed() -> void:
	if not GameData.SelectedMap or not GameData.SelectedDifficulty:
		return
	get_tree().change_scene_to_file("res://Scenes/editor.tscn")

func _on_play_pressed() -> void:
	if not GameData.SelectedMap or not GameData.SelectedDifficulty:
		return
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_open_song_folder_pressed() -> void:
	OS.shell_open(FileHandler.MusicFolderPath)
