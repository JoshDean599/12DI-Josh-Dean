extends Sprite2D

@onready var note = preload("res://Scenes/Objects/note.tscn")

var keyQueue = []

var scores = {
	ok = {
		lower = 0,
		upper = 400,
		score = 50
	},
	perfect = {
		lower = 30,
		upper = 60,
		score = 200
	},
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func hit_key(inputEvent):
	if inputEvent.is_echo() or keyQueue.size() <= 0:
		return
	if inputEvent.pressed:
		visible = false
		var keyToPop = keyQueue.pop_front()
		var distanceFromPass = abs(keyToPop.passedPosition - keyToPop.global_position.x)
		# Get score type
		var scoreType = "miss"
		for i in scores:
			if distanceFromPass > scores[i].lower and distanceFromPass < scores[i].upper:
				scoreType = i
		
		if scoreType != "miss":
			Signals.IncrimentScore.emit(scores[scoreType].score)
		
		keyToPop.queue_free()
	else:
		visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if keyQueue.size() > 0:
		# If that falling key has passed, remove it from the queue
		if keyQueue.front().hasPassed:
			keyQueue.pop_front()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		hit_key(event)

func create_falling_key():
	var noteInstance = note.instantiate()
	get_parent().get_child(0).call_deferred("add_child", noteInstance) # Change index from self!!
	noteInstance.setup(position.y)
	
	keyQueue.push_back(noteInstance)

func _on_random_timer_timeout() -> void:
	create_falling_key()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
