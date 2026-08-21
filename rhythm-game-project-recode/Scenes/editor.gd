extends Node2D

@onready var notes = $CanvasLayer/Notes
@onready var songName = $CanvasLayer/OptionsMenu/VBoxContainer/SaveMenu/MarginContainer/HBoxContainer/VBoxContainer/SongName
@onready var songSelectPopup = $CanvasLayer/OptionsMenu/VBoxContainer/SaveMenu/MarginContainer/HBoxContainer/VBoxContainer/SongsSelect
@onready var editorMenu = $CanvasLayer/OptionsMenu
var editorNote = preload("res://Scenes/Objects/editor_note.tscn")
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = 1

var testing = false
var testingStartPosition: Vector2
var testingEndTween: Tween

# Add save warnings when exiting editor

func _ready() -> void:
	editorMenu.visible = false
	songSelectPopup.get_popup().connect("index_pressed", on_song_select_popup_press)

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func _on_options_pressed() -> void:
	editorMenu.visible = !editorMenu.visible

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("save"):
		save_map()

func save_map() -> void:
	if songName.text.length() <= 0:
		print("Unable to save map: undefind file path.")
		return
	
	var saveData = {
		Notes = [],
		Song = songName.text,
		bufferTime = 5
	}
	var firstNote = null
	for i in notes.get_children(): # Insert each notes into the table
		if i == $CanvasLayer/Notes/Deadzone: continue
		if firstNote == null or firstNote.time > i.time:
			firstNote = i
		saveData.Notes.push_back(
			{
				time = i.time,
				offset = i.offset,
				tailTime = i.tailTime,
				tailOffset = i.tailOffset
			}
		)
	saveData.bufferTime = firstNote.time
	
	if FileAccess.file_exists("res://LoadedMaps/" + songName.text + ".json"):
		print("File Exists")
	else:
		print("File Doesn't exist, creating new")
	
	var file = FileAccess.open("res://LoadedMaps/" + songName.text + ".json", FileAccess.ModeFlags.WRITE)
	if file:
		var text = JSON.stringify(saveData, "\t")
		file.store_string(text)
		print("Data written to file")
	else:
		print("Failed to create new file or write to current")

func load_map() -> void:
	if songName.text.length() <= 0:
		# Clear all notes from the tree if loading no map
		for i in notes.get_children():
			i.free()
		return
	
	var loadedMap = get_parent().load_map(songName.text)
	if loadedMap == {}:
		return
	
	# Clear all notes from the tree
	for i in notes.get_children():
		i.free()
	
	for i in loadedMap.Notes:
		create_new_note(
			i.time,
			i.offset,
			i.tailTime,
			i.tailOffset
		)

func create_new_note(time: float, offset: float, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate()
	notes.add_child(newNote)
	
	if offset > get_parent().YCollumnHeight:
		offset = get_parent().YCollumnHeight
	elif offset <= 0:
		offset = 1
	
	# Limit the time to being within range
	if time < 0:
		time = 0
	
	newNote.time = time
	newNote.offset = offset
	newNote.tailTime = tailTime
	newNote.tailOffset = tailOffset
	
	newNote.update_position()

func _on_drag_detector_gui_input(event: InputEvent) -> void:
	if testing: return
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - notes.position
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				dragging = false
				if clickPosition.distance_to(get_global_mouse_position() - notes.position) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					create_new_note(
						snapped(clickPosition.x / get_parent().noteMoveSpeed, timeFrame), # Time
						snapped(clickPosition.y / (float(DisplayServer.window_get_size().y) / (get_parent().YCollumnHeight + 1)), 1), # Offset
						0, # tailTime
						0  # tailOffset
					)
	elif event is InputEventMouseMotion:
		if dragging:
			notes.position.x = snapped((get_global_mouse_position().x - clickPosition.x), get_parent().noteMoveSpeed)
			if notes.position.x > get_parent().noteMoveSpeed:
				notes.position.x = get_parent().noteMoveSpeed

func _on_save_pressed() -> void:
	save_map()

func _on_load_pressed() -> void:
	load_map()


func _on_test_pressed() -> void:
	testing = !testing
	if testing:
		$TimeHandler.play(-notes.position.x / get_tree().current_scene.noteMoveSpeed)
		testingStartPosition = notes.position
	else:
		$TimeHandler.pause()
		if testingEndTween:
			testingEndTween.kill()
		testingEndTween = create_tween()
		testingEndTween.set_ease(Tween.EASE_OUT) # Don't know if this does anything...
		testingEndTween.tween_property(notes, "position", testingStartPosition, .5)

func _process(_delta: float) -> void:
	if testing: # Move the notes along with the song
		notes.position.x = -get_tree().current_scene.noteMoveSpeed * $TimeHandler.time
	

func _on_songs_select_about_to_popup() -> void:
	print("popup")
	# Load songs:
	var dir = DirAccess.open("res://Assets/Songs/")
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while
		print(fileName)

func on_song_select_popup_press(index):
	pass
