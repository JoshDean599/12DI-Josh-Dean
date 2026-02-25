extends Node2D

const BASE_PATH = "res://Songs/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var file_path = BASE_PATH + "testing" + ".json"
	saveSong(file_path, {"L": "a"})
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func saveSong(path: String, data: Dictionary) -> void:
	if FileAccess.file_exists(path):
		print("File Exists")
	else:
		print("File Doesn't exist, creatingNew")
	
	var f = FileAccess.open(path, FileAccess.ModeFlags.WRITE)
	if f:
		var text = JSON.stringify(data, "\t")
		f.store_string(text)
		print("Data written to file")
	else:
		print("Failed to create or open")
