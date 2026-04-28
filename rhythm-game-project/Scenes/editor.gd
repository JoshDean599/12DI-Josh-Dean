extends Node2D

var Note = preload("res://Scenes/Objects/editor_note.tscn")


func _on_add_note_pressed() -> void:
	createNewNote()


func createNewNote() -> void:
	var newNote = Note.instantiate()
	$Notes.add_child(newNote)
	newNote.name = str($Notes.get_children().size())
	newNote.position = Vector2(500, 250)


func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func _on_save_pressed() -> void:
	if $UI/Control/VBoxContainer/FilePath.text.length() <= 0:
		return
	var saveData = {}
	for i in $Notes.get_children():
		saveData[i.name] = {
			position = {
				x = i.position.x,
				y = i.position.y
			}
		}
	save_map(Globals.basePath + $UI/Control/VBoxContainer/FilePath.text + ".json", saveData)


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
	var savePath = Globals.basePath + $UI/Control/VBoxContainer/FilePath.text + ".json"
	if savePath:
		var saveString = FileAccess.get_file_as_string(savePath)
		var saveAsDict = JSON.parse_string(saveString)
		
		var currentNote = null
		for i in saveAsDict:
			if int(i) > $Notes.get_children().size():
				createNewNote()
			var changingNote = $Notes.get_node(i)
			changingNote.position = Vector2(saveAsDict[i].position.x, saveAsDict[i].position.y)
			currentNote = int(i)
		
		if currentNote != null and $Notes.get_children().size() - currentNote > 0:
			for i in $Notes.get_children().size() - currentNote:
				print($Notes.get_child(currentNote))
				$Notes.get_child(currentNote - 1).queue_free()
				pass
			pass
