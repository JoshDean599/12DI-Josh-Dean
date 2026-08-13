extends Node2D


func setup(NoteHandler, noteSettings: Dictionary):
	#var songHandler = NoteHandler.songHandler
	var noteHandler = NoteHandler # Define the note handler
	var noteTime = noteSettings.time
	var holdEndTime =  noteSettings.time + noteSettings.tailTime
	# Set the notes initial position
	global_position = Vector2(noteSettings.time * get_tree().current_scene.noteMoveSpeed, noteSettings.offset)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailTime * get_tree().current_scene.noteMoveSpeed, noteSettings.tailOffset)
	
