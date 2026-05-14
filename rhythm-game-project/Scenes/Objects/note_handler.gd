extends Sprite2D

var noteQueue = [] #  Keeps track of what notes to process first
var activeNotes = [] # Keeps track of the active notes (Notes being held)
var heldKeys = {} # Keeps track of the held keys


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			#print("PRESSED ", event.keycode)
			heldKeys[event.keycode] = true
			#print(heldKeys)
			
			if noteQueue.size() > 0:
				var noteToPop = noteQueue.pop_front()
				noteToPop.activate()
				activeNotes.push_back(noteToPop)
		elif event.is_released():
			#print("RELEASED ", event.keycode)
			heldKeys[event.keycode] = false
			#print(heldKeys)
			
			var holding = false
			for i in heldKeys:
				if heldKeys[i]:
					holding = true 
			#print("Holding: ", holding)
			if not holding:
				for i in activeNotes:
					i.queue_free()
				activeNotes = []
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if noteQueue.size() > 0:
		# If that note has passed, remove it from the queue
		if noteQueue.front().hasPassed:
			var noteToPop = noteQueue.pop_front()
			noteToPop.queue_free()
		var currentPosition = 0
		var poppedNotes = 0
		for i in activeNotes:
			currentPosition += 1
			poppedNotes += 1
			if i.hasPassed:
				i.queue_free()
				activeNotes.pop_at(currentPosition - poppedNotes)
				print("Popped ActiveNotes")
	


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
