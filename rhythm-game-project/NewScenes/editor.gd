extends Node2D
# Can probably be cleaned up. :/ But it works

@onready var EditorNote = preload("res://NewScenes/Objects/editor_note.tscn")

# Click detector variables:
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime = 0

# The distance equal to 1 second in the editor
var viewSpeed = 250

func _ready() -> void:
	load_map()

func _on_back_button_pressed() -> void:
	save_map()
	get_tree().change_scene_to_file("res://NewScenes/song_select.tscn")


func _on_click_detector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# On left click
		if event.button_index == 1:
			if event.pressed:
				dragging = true
				clickPosition = get_local_mouse_position()
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				dragging = false
				#Create a new note if the click time was short enough and the mouse didn't move too far
				if clickPosition.distance_to(get_local_mouse_position()) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					create_note(
						clickPosition.x / viewSpeed, # Time
						clickPosition.y, # Offset
						0, # tailTime
						0  # tailOffset
					)
	elif event is InputEventMouseMotion:
		# Update the position when the mouse moved
		if dragging:
			$Camera2D.position.x += (clickPosition - get_local_mouse_position()).x
			if $Camera2D.position.x < 0:
				$Camera2D.position.x = 0

func create_note(time, offset, tailTime, tailOffset):
	var newNote = EditorNote.instantiate()
	$Notes.add_child(newNote)
	
	if time < 0:
		time = 0
	newNote.noteTime = time
	newNote.noteOffset = offset
	newNote.tailTime = tailTime
	newNote.tailOffset = tailOffset
	newNote.update_position()

func load_map() -> void:
	# Clear all notes from the tree
	for note in $Notes.get_children():
		note.free()
	
	var LoadedMap = FileHandler.load_file(FileHandler.SongFolderPath + "/" + GameData.SelectedMap + "/Difficulties/" + GameData.SelectedDifficulty + ".json")
	if LoadedMap == {}: # If the map could not be loaded, return
		return
	
	# Create each note
	for i in LoadedMap.Notes:
		create_note(
			i.time,
			i.offset,
			i.tailTime,
			i.tailOffset
		)

func save_map() -> void:
	# The base save data
	var saveData = {
		Notes = [],
	}
	# Add each note into the Notes[] within the save data
	var firstNote = null
	for i in $Notes.get_children(): # Insert each notes into the table
		if firstNote == null or firstNote.noteTime > i.noteTime: # Get the first note
			firstNote = i
		saveData.Notes.push_back(
			{
				time = i.noteTime,
				offset = i.noteOffset,
				tailTime = i.tailTime,
				tailOffset = i.tailOffset
			}
		)
	if not firstNote: # If there isn't any notes within the scene, return
		return
	saveData.bufferTime = firstNote.noteTime # Set the bufferTime to the firstNote's time
	
	FileHandler.edit_file(FileHandler.SongFolderPath + "/" + GameData.SelectedMap + "/Difficulties/" + GameData.SelectedDifficulty + ".json", saveData)
