extends Node2D

@onready var game = get_parent().get_parent()
@onready var audio = game.get_node("SongHandler").Audio

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


func _ready() -> void:
	var timeToNoteHandler = holdDuration + abs(position.x - game.get_node("NoteHandler").position.x) / movingSpeed
	if audio:
		holdEndTime = audio.get_playback_position() + timeToNoteHandler
	else:
		holdEndTime = timeToNoteHandler

func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	
	# Check held Note:
	if audio.get_playback_position() - holdEndTime >= 0 and not hasPassed:
		if isHolding:
			# Note Successfully held
			#print("CompletedNote")
			get_parent().get_parent().incriment_score(10) # Properly calculate score
			hasPassed = true
		else:
			# Missed Note
			#print("MissedNote")
			hasPassed = true
			pass
		
	else:
		if isHolding:
			# Do something to update the visual of the note
			pass
	
	
	# Check if the note no longer counts for hits
	#if global_position.x < passedPosition and not hasPassed:
	#	hasPassed = true
	# Clear the note once it's no longer in use
	if global_position.x < freeQueuePosition:
		hasPassed = true
	
	

func setup(notePosition: Vector2, tailPosition: Vector2):
	#Set the initial notes position
	global_position = notePosition
	# Setup the note tail
	$Tail.position =  tailPosition
	# Setup the duration
	holdDuration = abs(tailPosition.x / movingSpeed)
	
	

func activate() -> void:
	holdStartTime = audio.get_playback_position()
	isHolding = true
