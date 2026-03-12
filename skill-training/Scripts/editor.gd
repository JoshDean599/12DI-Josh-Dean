extends Node2D

@onready var basePath = get_parent().BASEPATH
var Note = preload("res://Scenes/editor_note.tscn")

func _on_create_new_note_button_pressed() -> void:
	createNewNote()

func createNewNote() -> void:
	var newNote = Note.instantiate()
	$Notes.add_child(newNote)
	newNote.name = str($Notes.get_children().size())

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

func _on_save_button_pressed() -> void:
	var saveData = {}
	for i in $Notes.get_children():
		saveData[i.name] = {
			position = {
				x = i.position.x,
				y = i.position.y
			}
		}
	save_map(basePath + $UI/SavePath.text + ".json", saveData)

func _on_load_button_pressed() -> void:
	var savePath = basePath + $UI/SavePath.text + ".json"
	if savePath:
		var saveString = FileAccess.get_file_as_string(savePath)
		var saveAsDict = JSON.parse_string(saveString)
		
		for i in saveAsDict:
			if int(i) > $Notes.get_children().size():
				createNewNote()
			var changingNote = $Notes.get_node(i)
			changingNote.position = Vector2(saveAsDict[i].position.x, saveAsDict[i].position.y)

func _on_close_editor_pressed() -> void:
	get_parent().change_scene(name, "MainMenu")
