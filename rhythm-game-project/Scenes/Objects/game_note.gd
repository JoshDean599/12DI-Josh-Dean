extends Node2D

var noteHandler = null # Gets set on setup before @onready

var noteTime := 0.0
var holdEndTime := 0.0

var freeQueueTime: float = -500.0
var active = false


func _process(_delta: float) -> void:
	# Check if the note is held:
	if active:
		if noteHandler.holding:
			if Globals.gameTime - holdEndTime >= 0: # Successfuly held note! - Change to proper range
				print("Success!")
				noteHandler.get_parent().incriment_score(10)
				queue_free()
			else:
				# Update visuals
				$Tail.modulate = Color(0.631, 0.886, 0.122, 1.0)
				pass
		else: # Stopped holding Note
			print("Fail")
			queue_free()
			pass
	
	
	# Clear the note once it's no longer in use
	if not active and Globals.gameTime > (noteTime + 1) * Globals.noteMoveSpeed:
		print("Freeing Note")
		queue_free()


func setup(NoteHandler, noteSettings: Dictionary):
	noteHandler = NoteHandler # Define the note handler
	noteTime = noteSettings.time
	
	var holdDuration = abs(noteSettings.tailPosition.x / Globals.noteMoveSpeed)
	holdEndTime = noteTime + holdDuration
	print(noteTime, " ", holdEndTime, " ", holdDuration)
	# Set the notes initial position
	global_position = Vector2(noteSettings.position.x, noteSettings.position.y)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailPosition.x, noteSettings.tailPosition.y)
	
