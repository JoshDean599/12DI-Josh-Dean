extends Node2D

const BASE_PATH = "res://Songs/"

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


func _on_button_pressed() -> void:
	saveMap(BASE_PATH + $LineEdit.text + ".json", {"Data": $LineEdit2.text})
