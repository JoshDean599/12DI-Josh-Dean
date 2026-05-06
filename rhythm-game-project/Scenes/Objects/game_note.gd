extends Node2D

var movingSpeed: float = 250.0

var duration: float = 0.0
var timerWaitTime: float = 1.0
var scoreTimes = {
	ok = {
		min = 3.0,
		max = 5.0,
		score = 50
	},
	perfect = {
		min = 3.9,
		max = 4.1,
		score = 200
	}
}

#var passedPosition: float = -515.0
var freeQueuePosition: float = -660.0

var hasPassed: bool = false


func _process(delta: float) -> void:
	# Move the note
	global_position -= Vector2(movingSpeed * delta, 0)
	
	
	
	# Check if the note no longer counts for hits
	#if global_position.x < passedPosition and not hasPassed:
	#	hasPassed = true
	# Clear the note once it's no longer in use
	if global_position.x < freeQueuePosition:
		queue_free()

func setup(notePosition: Vector2, tailPosition: Vector2):
	#Set the initial notes position
	global_position = notePosition
	# Setup the note tail
	$Tail.position =  tailPosition
	# Start the processing for the note
	set_process(true)
	
	$Timer.wait_time = timerWaitTime


func _on_timer_timeout() -> void:
	hasPassed = true
	pass # Replace with function body.

func hit() -> void:
	var score = "Miss"
	for i in scoreTimes:
		pass
	pass
