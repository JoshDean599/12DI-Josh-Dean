extends Node2D

@onready var filePath = $UI/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/FilePath
@onready var songName = $UI/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/VBoxContainer/SongName
@onready var songHandler = $Camera2D/SongHandler

@onready var camera = $Camera2D
var cameraOffset = 0
var dragging = false
var startDragPosition = Vector2.ZERO

var clickTime: float = 0.0
var clickPosition: Vector2i = Vector2.ZERO

var snapDistance: float = 1.0

var testing = false


func createNewNote(Position: Vector2, TailPosition: Vector2, setTime: float, offset: float) -> void:
	var newNote = Globals.EditorNote.instantiate()
	$Notes.add_child(newNote)
	
	print(setTime)
	newNote.time = setTime
	newNote.offset = offset
	
	newNote.position.x = snapped(Position.x, setTime * Globals.noteMoveSpeed)
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
				time = i.position.x / Globals.noteMoveSpeed,
				endTime = i.position.x / Globals.noteMoveSpeed + i.get_node("Tail").position.x / Globals.noteMoveSpeed,
				positionY = i.position.y - camera.position.y,
				tailY = i.get_node("Tail").position.y,
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
	if saveAsDict == {}:
		print("Unable to load map: Unknown File Path")
		return
		
	for i in $Notes.get_children(): # Remove all Editor Notes
		i.free() # Remove the note during the frame, unlike queue_free() which removes after the frame
	
	for i in saveAsDict.Notes: # Load the notes from the savePath
		createNewNote(
			Vector2(i.time * Globals.noteMoveSpeed, i.positionY), # Note Position
			Vector2(i.endTime * Globals.noteMoveSpeed, i.tailY), # Note Tail Position
			i.time,
			0.0
		)


func _on_return_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func _process(delta: float) -> void:
	if dragging and not testing:
		if Globals.editorGridLockKeyPress:
			camera.position.x = snapped(-(DisplayServer.mouse_get_position().x - startDragPosition), Globals.noteMoveSpeed)
		else:
			camera.position.x = -(DisplayServer.mouse_get_position().x - startDragPosition)
	$UI/MarginContainer/VBoxContainer/HBoxContainer/Label.text = "Time: " + str(round((camera.position.x / Globals.noteMoveSpeed)* 100) / 100)
	
	if testing:
		Globals.gameTime += delta
		camera.position.x = Globals.noteMoveSpeed * Globals.gameTime
	
	if camera.position.x < 0:
		camera.position.x = 0


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
		createNewNote( mousePosition + camera.position, Vector2(), snapped((mousePosition.x + camera.position.x) / Globals.noteMoveSpeed, snapDistance), 0.0)


func _on_drag_detector_gui_input(event: InputEvent) -> void: # Scrolling around the editor
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.position.x -= Globals.noteMoveSpeed * snapDistance / 2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.position.x += Globals.noteMoveSpeed * snapDistance / 2


func _on_play_button_pressed() -> void:
	Globals.gameTime = camera.position.x / Globals.noteMoveSpeed
	testing = true
	$UI/MarginContainer/VBoxContainer/HBoxContainer/PlayButton.visible = false
	$UI/MarginContainer/VBoxContainer/HBoxContainer/PauseButton.visible = true
	
	songHandler.play_song(Globals.gameTime)


func _on_pause_button_pressed() -> void:
	testing = false
	$UI/MarginContainer/VBoxContainer/HBoxContainer/PlayButton.visible = true
	$UI/MarginContainer/VBoxContainer/HBoxContainer/PauseButton.visible = false
	
	songHandler.stop_song()


func _on_option_button_item_selected(index: int) -> void:
	snapDistance = 1.0 / $UI/MarginContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/OptionButton.get_item_id(index)
	print(snapDistance)
