extends Node2D

var movingSpeed: float = 250.0
var initXPosition: float = 660.0

var passedPosition: float = -515.0
var freeQueuePosition: float = -660.0

var hasPassed: bool = false

func _init() -> void:
	set_process(false)

func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	# Check if the note no longer counts for hits
	if global_position.x < passedPosition and not hasPassed:
		hasPassed = true
	# Clear the note once it's no longer in use
	if global_position.x < freeQueuePosition:
		queue_free()

func setup(targetY: float, tailPosition: Vector2):
	#Set the initial notes position
	global_position = Vector2(initXPosition, targetY)
	# Setup the note tail
	$Tail.position =  tailPosition
	# Start the processing for the note
	set_process(true)
