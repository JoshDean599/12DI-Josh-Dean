extends Sprite2D

var noteQueue = []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		hit_key(event)

func hit_key(inputEvent) -> void:
	if inputEvent.is_echo() or noteQueue.size() <= 0:
		return
	if inputEvent.pressed:
		var noteToPop = noteQueue.pop_front()
		noteToPop.hit()
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
	noteInstance.setup(notePosition, tailPosition)
	
	noteQueue.push_back(noteInstance)

func _on_random_timer_timeout() -> void:
	create_note(Vector2(576.0, 324.0), Vector2.ZERO)
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
