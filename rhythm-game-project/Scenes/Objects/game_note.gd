extends Node2D

var noteHandler = null # Gets set on setup before @onready
var songHandler = null

var noteTime := 0.0
var holdEndTime := 0.0

var active = false


func _process(_delta: float) -> void:
	# Check if the note is held:
	if active:
		var distanceFromHit = songHandler.trueTime - holdEndTime
		if noteHandler.holding:
			#First condition for hold notes, second for single notes
			if distanceFromHit >= 0 or holdEndTime - noteTime == 0: # Successfuly held note!
				if distanceFromHit < noteHandler.scores.Bad.max and distanceFromHit > -noteHandler.scores.Bad.min:
					onSuccess()
				else:
					onFail()
				queue_free()
			else: # Holding note:
				# Update visuals
				$Tail.modulate = Color(0.0, 1.0, 0.0, 1.0)
				pass
		else: # Stopped holding Note -- Add some drop offset so you don't need to hold it for all the time to still pass it
			if distanceFromHit >= -noteHandler.scores.Bad.min:
				onSuccess()
			else:
				onFail()
			queue_free()
			pass
	
	# Clear the note once it's no longer in use
	if not active and songHandler.trueTime > noteTime + holdEndTime + 1 + noteHandler.scores.Miss.min:
		print("Freeing Note")
		queue_free()

func onSuccess():
	noteHandler.get_parent().incriment_score(10)
	print("Success!")
	pass

func onFail():
	print("Fail")
	pass

func setup(NoteHandler, noteSettings: Dictionary):
	songHandler = NoteHandler.songHandler
	noteHandler = NoteHandler # Define the note handler
	noteTime = noteSettings.time
	holdEndTime =  noteSettings.time + noteSettings.tailTime
	# Set the notes initial position
	global_position = Vector2(noteSettings.time * noteHandler.noteMoveSpeed, noteSettings.offset)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailTime * noteHandler.noteMoveSpeed, noteSettings.tailOffset)
	
