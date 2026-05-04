extends Node2D

@onready var filePath = $UI/Control/MarginContainer/VBoxContainer/PanelContainer/FilePath

func _on_add_note_pressed() -> void:
	createNewNote("", Vector2(), Vector2())


func createNewNote(Name: String, Position: Vector2, TailPosition: Vector2) -> void:
	var newNote = Globals.EditorNote.instantiate()
	$Notes.add_child(newNote)
	if Name == "":
		newNote.name = str($Notes.get_children().size())
	else:
		newNote.name = Name
	
	if Position == Vector2():
		newNote.position = Vector2(500, 250)
	else:
		newNote.position = Position
	
	newNote.get_node("Tail").position = TailPosition
	newNote.get_node("Line2D").set_point_position(1, TailPosition)


func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func _on_save_pressed() -> void:
	if filePath.text.length() <= 0:
		print("Unable to save map: undefind file path.")
		return
	var saveData = {}
	for i in $Notes.get_children():
		saveData[i.name] = {
			position = {
				x = i.position.x,
				y = i.position.y
			},
			tailPosition = {
				x = i.get_node("Tail").position.x,
				y = i.get_node("Tail").position.y
			}
		}
	save_map(Globals.basePath + filePath.text + ".json", saveData)


func save_map(path: String, data: Dictionary) -> void:
	if FileAccess.file_exists(path):
		print("File Exists")
	else:
		print("File Doesn't exist, creating new")
	
	var file = FileAccess.open(path, FileAccess.ModeFlags.WRITE)
	if file:
		var text = JSON.stringify(data, "\t")
		file.store_string(text)
		print("Data written to file")
	else:
		print("Failed to create new file or write to current")


func _on_load_pressed() -> void:
	#var savePath = Globals.basePath + filePath.text + ".json"
	## Only continue if the savePath is found and is valid
	#if filePath.text.length() <= 0 or not savePath:
	#	return
	#
	#var saveString = FileAccess.get_file_as_string(savePath)
	#var saveAsDict = JSON.parse_string(saveString)
	
	if filePath.text.length() <= 0:
		return
	 
	var saveAsDict = Globals.load_song(Globals.basePath + filePath.text + ".json")
	
	for i in $Notes.get_children(): # Remove all Editor Notes
		i.free() # Remove the note during the frame, unlike queue_free() which removes after the frame
	
	for i in saveAsDict: # Load the notes from the savePath
		createNewNote(
			i,																	# Note Name
			Vector2(saveAsDict[i].position.x, saveAsDict[i].position.y), 		# Note Position
			Vector2(saveAsDict[i].tailPosition.x, saveAsDict[i].tailPosition.y) # Note Tail Position
		)
