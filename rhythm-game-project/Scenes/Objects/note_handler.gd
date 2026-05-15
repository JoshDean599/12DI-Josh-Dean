extends Sprite2D

var noteQueue = [] #  Keeps track of what notes to process first
var activeNotes = [] # Keeps track of the active notes (Notes being held)
var heldKeys = {} # Keeps track of the held keys
var holding = false


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			heldKeys[event.keycode] = true
			
			#if noteQueue.size() > 0:
			#	var noteToPop = noteQueue.pop_front()
			#	noteToPop.activate()
			#	activeNotes.push_back(noteToPop)
		elif event.is_released():
			heldKeys[event.keycode] = false
			
			for i in heldKeys:
				if heldKeys[i]:
					holding = true 
			if not holding:
				for i in activeNotes:
					i.queue_free()
				activeNotes = []
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if noteQueue.size() > 0:
		# If that note has passed, remove it from the queue
		#if noteQueue.front().hasPassed:
		#	var noteToPop = noteQueue.pop_front()
		#	noteToPop.queue_free()
		
		# If an active note has passed, remove it from the queue
		#for i in activeNotes:
		#	if i.hasPassed:
		#		i.queue_free()
		#		activeNotes.pop_at(activeNotes.find(i))
		#		print("Popped ActiveNotes")
		#		
		
	


func create_note(notePosition: Vector2, tailPosition: Vector2) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteInstance.setup(notePosition, tailPosition)
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)


func _on_random_timer_timeout() -> void:
	create_note(Vector2(1200.0, randi_range(-100, 100)), Vector2(randi_range(0, 5) * 100, 0))
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
