extends Node2D

var trailLength: float = 0.0
var lengthMultiplier: float = 2.0

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

func setup(targetY: float, type: String, length: float):
	#Set the initial notes position
	global_position = Vector2(initXPosition, targetY)
	match type:
		"HoldNote":
			# Setup the note tail
			trailLength = length
			$Tail.position =  Vector2(length * lengthMultiplier, targetY)
	# Start the processing for the note
	set_process(true)
