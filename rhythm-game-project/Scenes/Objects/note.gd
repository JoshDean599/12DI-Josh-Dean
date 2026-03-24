extends Sprite2D

var timeAlive: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeAlive -= delta
	if timeAlive <= 0.0:
		queue_free() # Remove Note from play
	
