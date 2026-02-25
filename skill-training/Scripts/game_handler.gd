extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	
	
	
	#var json = JSON.new()
	#print(JSON.stringify(preload("res://Songs/FirstSong.json").data))
	#print(preload("res://Songs/FirstSong.json").data.Notes[0].Time)
	
	
	#var data = {
	#	"Data" : "Testing Data"
	#}
	
	#var file_path = "res://Songs/new_json.json"
	#if FileAccess.file_exists(file_path):
	#	print("File Exists")
	#else:
	#	print("File Doesn't exist")
	#
	#var f = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	#if f:
	#	var text = JSON.stringify(data, "\t")
	#	f.store_string(text)
	#	print("Data written to file")
	#else:
	#	print("Failed to create or open")
	#
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadSong() -> void:
	pass
