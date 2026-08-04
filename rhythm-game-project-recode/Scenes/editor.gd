extends Node2D

var editorNote = preload("res://Scenes/Objects/song_select_button.tscn") #PLACEHOLDER

func _on_visibility_changed() -> void:
	if visible:
		$Camera2D.

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func _on_save_map_pressed() -> void:
	pass # Replace with function body.

func _on_load_map_pressed() -> void:
	pass # Replace with function body.

func create_new_note(time: float, offset: float, tailTime: float, tailOffset: float) -> void:
	var newNote = editorNote.instantiate()
	$Notes.add_child(newNote)
	
	# Limit the time to being within range
	if time < 0:
		time = 0
	
	newNote.time = time
	newNote.offset = offset
	newNote.tailTime = tailTime
	newNote.tailOffset = tailOffset
	
	newNote.update_position()
	
