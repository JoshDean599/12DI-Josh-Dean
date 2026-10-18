extends Node2D

@onready var SongSelectMenu = get_parent().get_node("SongSelectMenu")


#Import nodes
@export var notes : Node2D
# Base Editor Variables
var editorNote = preload("res://Scenes/Objects/EditorObjects/editor_note.tscn")
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = .25
# Testing Variables
var testing = false
var testingStartPosition: Vector2
var testingEndTween: Tween

var noteClampMin = 250

# Add save warnings when exiting editor --------------------------------------------------------------!!!!!!!

func _ready() -> void:
	# Make the DragDetector fit to any screens size
	$DragDetector.set_deferred("size", DisplayServer.screen_get_size())
	$DragDetector.set_deferred("position", DisplayServer.screen_get_position(DisplayServer.SCREEN_OF_MAIN_WINDOW))

func _on_visibility_changed() -> void:
	if visible:
		if testing:
			testing = false
			# If music was playing, stop it
			$TimeHandler.pause()
		# Reset the notes position to the default
		notes.position = Vector2(noteClampMin, 0)

func load_map(mapName, mapDifficulty) -> void:
	# Clear all notes from the tree
	for note in notes.get_children():
		if note.name == "Deadzone": continue # Skip the deadzone as it's not a note
		note.free()
	
	var LoadedMap = get_parent().get_map(mapName, mapDifficulty)
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

func save_map() -> void:
	# The base save data
	var saveData = {
		Notes = [],
	}
	# Add each note into the Notes[] within the save data
	var firstNote = null
	for i in notes.get_children(): # Insert each notes into the table
		if i.name == "Deadzone": continue # Skip the dead zone as it's not a note
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
	saveData.bufferTime = firstNote.time # Set the bufferTime to the firstNote's time
	
	get_parent().create_or_modify_file(get_parent().SongMapDirPath + "/" + SongSelectMenu.SelectedSongButton.text + "/Difficulties", SongSelectMenu.SelectedDifficultyButton.text, saveData, true)

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
			notes.position.x = get_global_mouse_position().x - clickPosition.x
			if notes.position.x > noteClampMin:
				notes.position.x = noteClampMin

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
	

func _on_save_pressed() -> void:
	save_map()


func _on_time_frame_item_selected(index: int) -> void:
	#--------------------------------
	timeFrame = $CanvasLayer/ControlButtons/HboxContainer/TimeFrame.get_item_text(index)
