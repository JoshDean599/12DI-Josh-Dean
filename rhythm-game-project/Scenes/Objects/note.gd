extends Sprite2D

var movingSpeed: float = 250.0
var initXPosition: float = 660.0

var passedPosition: float = -515.0
var freeQueuePosition: float = -660.0

var hasPassed: bool = false

func _init() -> void:
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position -= Vector2(movingSpeed * delta, 0)
	
	if global_position.x < passedPosition and not hasPassed:
		hasPassed = true
	
	if global_position.x < freeQueuePosition:
		queue_free()

func setup(targetY: float):
	global_position = Vector2(initXPosition, targetY)
	set_process(true)
