extends Node2D

var editorNote = preload("res://Scenes/Objects/editor_note.tscn")
var dragDetectorStart = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = 1

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func _on_save_map_pressed() -> void:
	pass # Replace with function body.

func _on_load_map_pressed() -> void:
	pass # Replace with function body.

func create_new_note(time: float, offset: float, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate()
	$Notes.add_child(newNote)
	print(time)
	time = snapped(time / get_parent().noteMoveSpeed, timeFrame)
	print(time)
	# Limit the time to being within range
	if time < 0:
		time = 0
	
	
	newNote.time = time
	newNote.offset = offset
	newNote.tailTime = tailTime
	newNote.tailOffset = tailOffset
	
	newNote.update_position()

func _on_drag_detector_button_down() -> void:
	dragDetectorStart = DisplayServer.mouse_get_position()
	clickTime = Time.get_ticks_msec() / 1000.0

func _on_drag_detector_button_up() -> void:
	if dragDetectorStart.distance_to(DisplayServer.mouse_get_position()) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
		var mousePosition = Vector2(DisplayServer.mouse_get_position() - DisplayServer.window_get_position()) + $Notes.position
		create_new_note(mousePosition.x, DisplayServer.window_get_size().y / 2, 0, 0)
