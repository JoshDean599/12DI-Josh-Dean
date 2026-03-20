extends Sprite2D

@export var fallingSpeed: float = 3.5
var initYPosition: float = -360.0

var passedPosition: float = 314.0
var freeQueuePosition: float = 400.0

var hasPassed: bool = false

func _init() -> void:
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += Vector2(0, fallingSpeed)
	
	if global_position.y > passedPosition and not hasPassed:
		hasPassed = true
	
	if global_position.y > freeQueuePosition:
		queue_free()

func setup(targetX: float):
	global_position = Vector2(targetX, initYPosition)
	set_process(true)
