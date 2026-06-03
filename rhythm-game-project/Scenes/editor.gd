extends Node2D

@onready var filePath = $UI/Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/FilePath
@onready var songName = $UI/Control/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/SongName

@export var noteSpeed = 250

@onready var camera = $Camera2D
var cameraOffset = 0
var dragging = false
var startDragPosition = Vector2.ZERO

var clickTime: float = 0.0
var clickPosition: Vector2i = Vector2.ZERO



func createNewNote(Position: Vector2, TailPosition: Vector2) -> void:
	var newNote = Globals.EditorNote.instantiate()
	$Notes.add_child(newNote)
	
	newNote.position.x = Position.x
	newNote.position.y = Position.y
	
	newNote.get_node("Tail").position = TailPosition
	newNote.get_node("Line2D").set_point_position(1, TailPosition)


func _on_save_pressed() -> void:
	if filePath.text.length() <= 0:
		print("Unable to save map: undefind file path.")
		return
	
	var saveData = {
		Notes = [],
		Song = songName.text
		}
	for i in $Notes.get_children(): # Insert each notes into the table
		saveData.Notes.push_back(
			{
				time = i.position.x / noteSpeed,
				position = {
					x = i.position.x - camera.position.x,
					y = i.position.y - camera.position.y
				},
				tailPosition = {
					x = i.get_node("Tail").position.x,
					y = i.get_node("Tail").position.y
				}
			}
		)
	save_map(Globals.mapPath + filePath.text + ".json", saveData)


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
	var saveAsDict = Globals.load_song(Globals.mapPath + filePath.text + ".json")
	
	for i in $Notes.get_children(): # Remove all Editor Notes
		i.free() # Remove the note during the frame, unlike queue_free() which removes after the frame
	
	for i in saveAsDict.Notes: # Load the notes from the savePath
		createNewNote(
			Vector2(i.position.x, i.position.y), # Note Position
			Vector2(i.tailPosition.x, i.tailPosition.y) # Note Tail Position
		)


func _on_return_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func _process(_delta: float) -> void:
	if dragging:
		camera.position.x = -(DisplayServer.mouse_get_position().x - startDragPosition)
		$UI/Control/MarginContainer2/Label.text = "Time: " + str(camera.position.x / noteSpeed)


func _on_drag_detector_button_down() -> void:
	dragging = true
	startDragPosition = DisplayServer.mouse_get_position().x + camera.position.x
	
	clickPosition = DisplayServer.mouse_get_position()
	clickTime = Time.get_ticks_msec() / 1000.0


func _on_drag_detector_button_up() -> void:
	dragging = false
	
	if clickPosition == DisplayServer.mouse_get_position() and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
		var mousePosition = Vector2(
			float(DisplayServer.mouse_get_position().x) - float(DisplayServer.screen_get_size().x) / 2,
			float(DisplayServer.mouse_get_position().y) - float(DisplayServer.screen_get_size().y) / 2
		)
		createNewNote( mousePosition + camera.position, Vector2())
