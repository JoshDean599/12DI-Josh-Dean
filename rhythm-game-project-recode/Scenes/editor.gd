extends Node2D

#Import nodes
@export var notes : Node2D
@export var songSelectPopup : Control
@onready var optionsMenu = $CanvasLayer/OptionsMenu
@onready var editorButtons = $CanvasLayer/ControlButtons
@onready var fileList = $CanvasLayer/OptionsMenu/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LoadOptions/FileList
# Base Editor Variables
var editorNote = preload("res://Scenes/Objects/editor_note.tscn")
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = 1
# Testing Variables
var testing = false
var testingStartPosition: Vector2
var testingEndTween: Tween
# Song information
var selectedSong = "NEFFEX - Hate It or Love It Copyright Free No82"
var loadedMap: String = ""
var difficulty: String = "Normal"
var difficultyLevel: int = 1

# Add save warnings when exiting editor --------------------------------------------------------------!!!!!!!

func _ready() -> void:
	# Make the DragDetector fit to any screens size
	$DragDetector.set_deferred("size", DisplayServer.screen_get_size())
	$DragDetector.set_deferred("position", DisplayServer.screen_get_position(DisplayServer.SCREEN_OF_MAIN_WINDOW))
	# Connect the menu song popup so that the index's can get pressed
	songSelectPopup.get_popup().connect("index_pressed", on_song_select_popup_press)

func _on_visibility_changed() -> void:
	if visible:
		editorButtons.visible = false
		optionsMenu.visible = true
		set_load_map(false)
		if testing:
			toggle_testing()
		return

func save_map() -> void:
	# The base save data
	var saveData = {
		Notes = [],
		DifficultyLevel = difficultyLevel,
		Song = selectedSong,
	}
	# Add each note into the Notes[] within the save data
	var firstNote = null
	for i in notes.get_children(): # Insert each notes into the table
		if i.name == "Deadzone": continue
		if firstNote == null or firstNote.time > i.time: # Get the first note
			firstNote = i
		saveData.Notes.push_back(
			{
				time = i.time,
				offset = i.offset,
				tailTime = i.tailTime,
				tailOffset = i.tailOffset
			}
		)
	if not firstNote: # If there isn't any notes within the scene, return
		return
	saveData.bufferTime = firstNote.time # Set the bufferTime based off the firstNote's time
	
	# Check if the file trying to be saved already exists:
	if FileAccess.file_exists(get_parent().SongMapDirPath + "/" + loadedMap + "/" + difficulty + ".json"):
		print("File Exists")
	else:
		print("File Doesn't exist, creating new")
	# Create or override the map
	var file = FileAccess.open(get_parent().SongMapDirPath + "/" + loadedMap + "/" + difficulty + ".json", FileAccess.ModeFlags.WRITE)
	if file:
		var text = JSON.stringify(saveData, "\t") # Convert it into a string for the json to store
		file.store_string(text)
		print("Data written to file")
	else:
		print("Failed to create new file or write to current")

func load_map(mapName, mapDifficulty) -> void:
	# Clear all notes from the tree
	for i in notes.get_children():
		if i.name == "Deadzone": continue
		i.free()
	
	var LoadedMap = get_parent().load_map(mapName, mapDifficulty)
	if LoadedMap == {}: # If the map could not be loaded, return
		return
	
	# Create each note
	for i in LoadedMap.Notes:
		create_new_note(
			i.time,
			i.offset,
			i.tailTime,
			i.tailOffset
		)
	
	optionsMenu.visible = false
	editorButtons.visible = true
	
	loadedMap = mapName

func create_new_note(time: float, offset: float, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate() # Create a new instance of the editor note
	notes.add_child(newNote)
	
	# Limit the height to the defined offset height
	if offset > get_parent().YCollumnHeight:
		offset = get_parent().YCollumnHeight
	elif offset <= 0:
		offset = 1
	
	# Limit the time to being within range
	if time < 0:
		time = 0
	
	# Set the notes variables
	newNote.time = time
	newNote.offset = offset
	newNote.tailTime = tailTime
	newNote.tailOffset = tailOffset
	# Update its position
	newNote.update_position()

func _on_drag_detector_gui_input(event: InputEvent) -> void:
	# Don't drag if editing
	if testing: return
	if event is InputEventMouseButton:
		# On left click
		if event.button_index == 1:
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - notes.position
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				dragging = false
				#Create a new note if the click time was short enough and the mouse didn't move too far
				if clickPosition.distance_to(get_global_mouse_position() - notes.position) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					create_new_note(
						snapped(clickPosition.x / get_parent().noteMoveSpeed, timeFrame), # Time
						snapped(clickPosition.y / (float(DisplayServer.window_get_size().y) / (get_parent().YCollumnHeight + 1)), 1), # Offset
						0, # tailTime
						0  # tailOffset
					)
	elif event is InputEventMouseMotion:
		# Update the position when the mouse moved
		if dragging:
			notes.position.x = snapped((get_global_mouse_position().x - clickPosition.x), get_parent().noteMoveSpeed)
			if notes.position.x > get_parent().noteMoveSpeed:
				notes.position.x = get_parent().noteMoveSpeed

func _on_test_pressed() -> void:
	toggle_testing()

func toggle_testing() -> void:
	# Toggle testing
	testing = !testing
	if testing:
		# Play the music
		$TimeHandler.play(-notes.position.x / get_tree().current_scene.noteMoveSpeed)
		# Set the position to return to when the testing ends
		testingStartPosition = notes.position
	else:
		# Stop the music
		$TimeHandler.pause()
		# Tween to the posiiton where the testing started
		if testingEndTween:
			testingEndTween.kill()
		testingEndTween = create_tween()
		testingEndTween.tween_property(notes, "position", testingStartPosition, .2)

func _process(_delta: float) -> void:
	if testing: # Move the notes along with the song when testing
		notes.position.x = -get_tree().current_scene.noteMoveSpeed * $TimeHandler.time

func _on_songs_select_about_to_popup() -> void:
	# Clear all the songs in the popup menu
	songSelectPopup.get_popup().clear()
	
	var songs = get_parent().get_file_list("res://Assets/Songs/") # !!!!!!!!--------------!!!!------------------------!!!!!----------!!!!!!---------------------------------------------------------------------------------------------------------------
	for song in songs:
		song = get_parent().remove_file_name_type(song, ".mp3")
		if song == "": # If it wasn't an mp3 file, discard
			continue
		# Add it to the popup menu
		songSelectPopup.get_popup().add_item(song, songSelectPopup.item_count + 1)

func on_song_select_popup_press(index):
	# Set the song on select
	selectedSong = songSelectPopup.get_popup().get_item_text(index)
	$TimeHandler.set_music(selectedSong)


func _on_open_map_folder_pressed() -> void:
	# Open the map folder location in the device's file manager
	OS.shell_open(get_parent().SongMapDirPath)


func _on_load_create_map_button_pressed() -> void:
	# Change the option shown on press
	if $CanvasLayer/OptionsMenu/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LoadOptions.visible:
		set_load_map(true)
	else:
		set_load_map(false)

func set_load_map(type: bool) -> void:
	# Logic to invert the selected option, based on a bool
	var vbox = $CanvasLayer/OptionsMenu/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer
	vbox.get_node("LoadOptions").visible = not type
	vbox.get_node("CreateOptions").visible = type
	if type:
		vbox.get_node("Load_CreateMapButton").text = "Load Map"
	else:
		fileList.refresh_list()
		vbox.get_node("Load_CreateMapButton").text = "Create Map"


func _on_create_new_map_button_pressed() -> void:
	var mapName = $CanvasLayer/OptionsMenu/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/CreateOptions/MapName
	var dir = DirAccess.open(get_parent().SongMapDirPath)
	if dir:
		if dir.dir_exists(mapName.text):
			dir.change_dir(dir.get_current_dir() + "/" + mapName.text)
		else:
			print("Created new song folder")
			dir.make_dir(mapName.text)
			dir.change_dir(dir.get_current_dir() + "/" + mapName.text)
