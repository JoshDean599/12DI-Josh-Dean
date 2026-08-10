extends Node2D

var editorNote = preload("res://Scenes/Objects/editor_note.tscn")
var dragging = false
var clickPosition = Vector2.ZERO
var clickTime: float = 0.0
var timeFrame = 1

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func _on_save_map_pressed() -> void:
	pass # Replace with function body.

func _on_load_map_pressed() -> void:
	pass # Replace with function body.

func create_new_note(impPosition, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate()
	$Notes.add_child(newNote)
	
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
				clickPosition = Vector2(DisplayServer.mouse_get_position()) - $Notes.position
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				dragging = false
				if clickPosition.distance_to(DisplayServer.mouse_get_position()) < 20.0 and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					var mousePosition = Vector2(DisplayServer.mouse_get_position() - DisplayServer.window_get_position()) + $Notes.position
					create_new_note(mousePosition, 0, 0)
	elif event is InputEventMouseMotion:
		if dragging:
			$Notes.position.x = snapped((DisplayServer.mouse_get_position().x - clickPosition.x), get_parent().noteMoveSpeed)
