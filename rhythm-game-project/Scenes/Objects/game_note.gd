extends Node2D

@onready var game = noteHandler.get_parent()
var noteHandler = null

# The speed the note moves
var movingSpeed: float = 250.0
# The duration the note needs to be held for to successfully count. If 0 then regular note.
var holdDuration: float = 0.0
var holdStartTime: float = 0.0
var holdEndTime: float = 0.0 # Change on creation
var isHolding: bool = false


#var passedPosition: float = -515.0
var freeQueuePosition: float = 0.0
var hasPassed: bool = false


func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	
	# Check if the note is held:
	if game.currentTime - holdEndTime >= 0 and not hasPassed:
		if noteHandler.holding:
			# Note Successfully held
			#print("CompletedNote")
			game.incriment_score(10) # Properly calculate score
			hasPassed = true
		else:
			# Missed Note
			#print("MissedNote")
			hasPassed = true
			pass
		
	else:
		if noteHandler.holding:
			# Do something to update the visual of the note
			pass
	
	
	# Check if the note no longer counts for hits
	#if global_position.x < passedPosition and not hasPassed:
	#	hasPassed = true
	# Clear the note once it's no longer in use
	if global_position.x < freeQueuePosition:
		#print("HasPassed")
		hasPassed = true
	
	if hasPassed:
		if noteHandler.noteQueue.find(self) >= 0:
			#print("Removing Note")
			noteHandler.noteQueue.pop_at(noteHandler.noteQueue.find(self))
			queue_free()
	

func setup(noteHAndler, noteSettings: Dictionary, currentTime):
	noteHandler = noteHAndler # Define the note handler
	
	holdDuration = abs(noteSettings.tailPosition.x / movingSpeed)
	
	holdEndTime = (noteSettings.position.x - noteHAndler.position.x + 64) / movingSpeed + currentTime
	
	# Set the notes initial position
	global_position = Vector2(noteSettings.position.x, noteSettings.position.y)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailPosition.x, noteSettings.tailPosition.y)
	
