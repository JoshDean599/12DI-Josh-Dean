extends Node2D

const BASE_PATH = "res://SongMaps/"
var Note = preload("res://Scenes/editor_note.tscn")
var noteAmmount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func saveMap(path: String, data: Dictionary) -> void:
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
		saveData[i.name] = {}
		saveData[i.name].time = i.timeValue
	
	saveMap(BASE_PATH + $UI/SavePath.text + ".json", saveData)

func _on_create_new_note_button_pressed() -> void:
	var newNote = Note.instantiate()
	$Notes.add_child(newNote)
	newNote.name = str(noteAmmount)
	noteAmmount += 1

func _on_load_button_pressed() -> void:
	var savePath = BASE_PATH + $UI/SavePath.text + ".json"
	if savePath:
		var saveString = FileAccess.get_file_as_string(savePath)
		var saveAsDict = JSON.parse_string(saveString)
		print(saveAsDict)
		
		
	
	pass # Replace with function body.
