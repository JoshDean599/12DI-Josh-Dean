extends Sprite2D

var noteQueue = []

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		hit_key(event)

func hit_key(inputEvent) -> void:
	if inputEvent.is_echo() or noteQueue.size() <= 0:
		return
	if inputEvent.pressed:
		var noteToPop = noteQueue.pop_front()
		var distanceFromPass = abs(noteToPop.passedPosition - noteToPop.global_position.x)
		# Get score type
		var scoreType = "miss"
		for i in scores:
			if distanceFromPass > scores[i].lower and distanceFromPass < scores[i].upper:
				scoreType = i
		
		if scoreType != "miss":
			get_parent().incriment_score(scores[scoreType].score)
		
		noteToPop.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if noteQueue.size() > 0:
		# If that note has passed, remove it from the queue
		if noteQueue.front().hasPassed:
			noteQueue.pop_front()
	

func create_note(noteType, length: float) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	get_parent().get_node("Notes").call_deferred("add_child", noteInstance) # Change index from self!!
	noteInstance.setup(position.y, noteType, length)
	
	noteQueue.push_back(noteInstance)

func _on_random_timer_timeout() -> void:
	create_note("BaseNote", 50)
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
