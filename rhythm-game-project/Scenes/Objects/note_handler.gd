extends Sprite2D

var noteQueue = [] #  Keeps track of what notes to process first
var heldKeys = [] # Keeps track of the held keys


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo() and noteQueue.size() > 0:
		if event.pressed:
			heldKeys.push_back(event.keycode)
			var noteToPop = noteQueue.pop_front()
			noteToPop.activate()
		else:
			for i in heldKeys:
				if heldKeys == event.keycode: # FIX HELDKEY GETTING CODE
					heldKeys.pop_at(i)
		print(heldKeys)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if noteQueue.size() > 0:
		# If that note has passed, remove it from the queue
		if noteQueue.front().hasPassed:
			noteQueue.pop_front()
	


func create_note(notePosition: Vector2, tailPosition: Vector2) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	get_parent().get_node("Notes").call_deferred("add_child", noteInstance) # Change index from self!!
	noteInstance.setup(notePosition, tailPosition)
	# Adds the note to the end of the note queue
	noteQueue.push_back(noteInstance)


func _on_random_timer_timeout() -> void:
	create_note(Vector2(1200.0, randi_range(100, 500)), Vector2(randi_range(0, 5) * 100, 0))
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
