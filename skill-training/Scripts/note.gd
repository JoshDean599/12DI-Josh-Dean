extends Sprite2D

var ACTIVE = true

var time = 5
@export var minOffset = 0.5
@export var maxOffset = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time -= delta
	if time >= minOffset and time <= maxOffset:
		rotate(1)
		if Input.is_action_just_pressed("input"):
			print("Yay")
	
	if time <= 0:
		time += 5
		print("time reset")
