extends Node2D

var desitedSpawnLocation = 1200

var noteHandler = null # Gets set on setup before @onready
@onready var game = noteHandler.get_parent()

var movingSpeed: float = 0.0
var holdEndTime: float = 0.0

var freeQueuePosition: float = -500.0
var active = false


func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	
	# Check if the note is held:
	if active:
		if noteHandler.holding:
			if game.currentTime - holdEndTime >= 0: # Successfuly held note! - Change to proper range
				game.incriment_score(10)
				queue_free()
			else:
				# Update visuals 
				pass
		else: # Stopped holding Note
			queue_free()
			pass
	
	
	# Clear the note once it's no longer in use
	if not active and global_position.x < freeQueuePosition:
		queue_free()


func setup(NoteHandler, noteSettings: Dictionary, currentTime):
	noteHandler = NoteHandler # Define the note handler
	movingSpeed = Globals.noteMoveSpeed # Overrides the variable before an @onready could
	noteSettings.position.x = + NoteHandler.position.x + 64 + (round(currentTime* 10) / 10 - noteSettings.time) * movingSpeed
	print(round(currentTime* 10) / 10, " ", noteSettings.time, " ", currentTime - noteSettings.time)
	# Speed = distance / time
	# distance = speed * time
	# time =  distance / speed
	
	var holdDuration = abs(noteSettings.tailPosition.x / movingSpeed)
	var endTime = (noteSettings.position.x - NoteHandler.position.x + 64) / movingSpeed + currentTime + holdDuration
	holdEndTime = endTime
	
	# Set the notes initial position
	global_position = Vector2(noteSettings.position.x, noteSettings.position.y)
	# Setup the notes tail position
	$Tail.position =  Vector2(noteSettings.tailPosition.x, noteSettings.tailPosition.y)
	
