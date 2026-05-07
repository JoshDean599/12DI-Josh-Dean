extends Sprite2D

var noteQueue = []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo() and noteQueue.size() > 0:
		if event.pressed:
			var noteToPop = noteQueue.pop_front()
			get_parent().incriment_score(noteToPop.on_hit())
			
			if noteToPop.duration == 0.0: # If the note is not a hold note
				noteToPop.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if noteQueue.size() > 0:
		# If that note has passed, remove it from the queue
		if noteQueue.front().hasPassed:
			noteQueue.pop_front()
	

func create_note(notePosition: Vector2, tailPosition: Vector2) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	get_parent().get_node("Notes").call_deferred("add_child", noteInstance) # Change index from self!!
	noteInstance.setup(get_parent().currentTime + 2.0, notePosition, tailPosition)
	
	noteQueue.push_back(noteInstance)

func _on_random_timer_timeout() -> void:
	create_note(Vector2(576.0, 324.0), Vector2.ZERO)
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
