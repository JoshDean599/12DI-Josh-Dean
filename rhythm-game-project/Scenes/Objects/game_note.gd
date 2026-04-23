extends Node2D

var trailLength: float = 0.0
var lengthMultiplier: float = 1.0

var movingSpeed: float = 250.0
var initXPosition: float = 660.0

var passedPosition: float = -515.0
var freeQueuePosition: float = -660.0

var hasPassed: bool = false

func _init() -> void:
	set_process(false)

func _process(delta: float) -> void:
	global_position -= Vector2(movingSpeed * delta, 0)
	
	if global_position.x < passedPosition and not hasPassed:
		hasPassed = true
	
	if global_position.x < freeQueuePosition:
		queue_free()

func setup(targetY: float, length: float):
	global_position = Vector2(initXPosition, targetY)
	trailLength = length
	$Tail.position = length * lengthMultiplier
	set_process(true)
