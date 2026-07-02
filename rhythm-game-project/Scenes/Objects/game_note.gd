extends Node2D

var noteHandler = null # Gets set on setup before @onready
var songHandler = null

var noteTime := 0.0
var holdEndTime := 0.0

var active = false


func _process(_delta: float) -> void:
	# Check if the note is held:
	if active:
		if noteHandler.holding:
			if songHandler.trueTime - holdEndTime >= 0 or holdEndTime - noteTime == 0: # Successfuly held note! - Change to proper range
				print("Success!")
				noteHandler.get_parent().incriment_score(10)
				queue_free()
			else: # Holding note:
				# Update visuals
				$Tail.modulate = Color(0.631, 0.886, 0.122, 1.0)
				pass
		else: # Stopped holding Note
			print("Fail")
			queue_free()
			pass
	
	
	# Clear the note once it's no longer in use
	if not active and songHandler.trueTime > noteTime + holdEndTime + 1:
		print("Freeing Note")
		queue_free()


func setup(NoteHandler, noteSettings: Dictionary):
	songHandler = NoteHandler.songHandler
	noteHandler = NoteHandler # Define the note handler
	noteTime = noteSettings.time
	holdEndTime =  noteSettings.time + noteSettings.tailTime
	# Set the notes initial position
	global_position = Vector2(noteSettings.time * noteHandler.noteMoveSpeed, noteSettings.offset)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailTime * noteHandler.noteMoveSpeed, noteSettings.tailOffset)
	
