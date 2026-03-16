extends Sprite2D

@export var fallingSpeed: float = 3.5
var initYPosition: float = -360

var passedPosition: float = 250
var freeQueuePosition: float = 400

var hasPassed: bool = false

func _init() -> void:
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(0, fallingSpeed)
	
	# Get the time to a "perfect" hit
	if global_position.y > passedPosition and not $Timer.is_stopped():
		print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		hasPassed = true
	
	if global_position.y > freeQueuePosition:
		queue_free()

func setup(targetX: float):
	global_position = Vector2(targetX, initYPosition)
	set_process(true)
