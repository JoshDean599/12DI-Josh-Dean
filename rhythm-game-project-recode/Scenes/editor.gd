extends Node2D

@onready var notes = $CanvasLayer/DragDetector/Notes
@onready var songName = $CanvasLayer/OptionsMenu/VBoxContainer/PanelContainer/HBoxContainer/SongName
@onready var saveMenu = $CanvasLayer/OptionsMenu
var editorNote = preload("res://Scenes/Objects/editor_note.tscn")
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = 1

func _ready() -> void:
	saveMenu.visible = false

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func _on_options_pressed() -> void:
	saveMenu.visible = !saveMenu.visible

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
	for i in notes.get_children(): # Insert each notes into the table
		saveData.Notes.push_back(
			{
				time = i.time,
				offset = i.offset,
				tailTime = i.tailTime,
				tailOffset = i.tailOffset
			}
		)
	
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

func create_new_note(impPosition, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate()
	notes.add_child(newNote)
	
	var time = snapped(impPosition.x / get_parent().noteMoveSpeed, timeFrame)
	var offset = snapped(impPosition.y / (float(DisplayServer.window_get_size().y) / (get_parent().YCollumnHeight + 1)), 1)
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
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - notes.position
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				dragging = false
				if clickPosition.distance_to(get_global_mouse_position() - notes.position) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					create_new_note(clickPosition, 0, 0)
	elif event is InputEventMouseMotion:
		if dragging:
			notes.position.x = snapped((get_global_mouse_position().x - clickPosition.x), get_parent().noteMoveSpeed)
			if notes.position.x > get_parent().noteMoveSpeed:
				notes.position.x = get_parent().noteMoveSpeed
