extends Node2D

@onready var game = get_parent().get_parent()

var movingSpeed: float = 250.0

var duration: float = 0.0 # How long it needs to be held down for

#var passedPosition: float = -515.0
var freeQueuePosition: float = -660.0
var noteTime: float = 0.0 # Gets updated when created
var hasPassed: bool = false


func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	
	
	# Check if the note no longer counts for hits
	#if global_position.x < passedPosition and not hasPassed:
	#	hasPassed = true
	# Clear the note once it's no longer in use
	if global_position.x < freeQueuePosition:
		hasPassed = true
		queue_free()

func setup(NoteTime: float, notePosition: Vector2, tailPosition: Vector2):
	#Set the initial notes position
	global_position = notePosition
	# Setup the note tail
	$Tail.position =  tailPosition
	# Set the time of the note:
	noteTime = NoteTime
	# Start the processing for the note
	set_process(true)
	


func on_hit() -> int:
	var time = game.currentTime
	var score = 0
	
	print(game.scores)
	for i in game.scores:
		print(i)
		if time > i.lower and time < i.upper:
			score = i.score
	
	return score
