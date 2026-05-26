extends Sprite2D

@onready var game = get_parent()

var noteQueue = [] #  Keeps track of what notes to process first
var heldKeys = [] # Keeps track of the held keys
var holding = false

var loadedSong = null

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			if heldKeys.find(event.keycode) == -1:
				heldKeys.push_back(event.keycode)
			
			if noteQueue.size() > 0 and noteQueue.front().position.x < 250: # Change to a proper range
				var noteToPop = noteQueue.pop_front()
				noteToPop.active = true
		elif event.is_released():
			if heldKeys.find(event.keycode) >= 0:
				heldKeys.pop_at(heldKeys.find(event.keycode))
		
		# Update holding:
		if heldKeys.size():
			holding = true
		else:
			holding = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Remove if passed point of hitting
	if noteQueue.size() > 0 and noteQueue.front().position.x < 0.0: # Change to proper range
		noteQueue.pop_front()
	
	if loadedSong != null and loadedSong.Notes.size() > 0:
		check_note()
	
	pass
	


func create_note(noteSettings: Dictionary) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteSettings.position.y -= self.position.y
	noteInstance.setup(self, noteSettings, get_parent().currentTime)
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)

func remove_note(id):
	if noteQueue.get(id):
		var noteToPop = noteQueue.get(id)
		noteToPop.queue_free()
		pass
	pass


func load_song(song):
	loadedSong = Globals.load_song(Globals.mapPath + song + ".json")


func check_note():
	var closestNote = 0 # Index of closest note
	var currentIndex = 0
	for i in loadedSong.Notes:
		if loadedSong.Notes[currentIndex].time < loadedSong.Notes[closestNote].time:
			closestNote = currentIndex
		currentIndex += 1
	print("Note time: ", loadedSong.Notes[closestNote].time, " Added time: ", loadedSong.Notes[closestNote].time + game.bufferTime, " CurrentTime: ", game.currentTime)
	
	if loadedSong.Notes[closestNote].time + game.bufferTime <= game.currentTime:
		print("CreatedNote: ", loadedSong.Notes[closestNote])
		create_note(loadedSong.Notes.pop_at(closestNote))
	



#func _on_random_timer_timeout() -> void:
#	create_note(
#		{
#			position = {
#				x = 1200.0,
#				y = randi_range(-100, 100)
#			},
#			tailPosition = {
#				x = randi_range(0, 3) * 100,
#				y = 0
#			}
#		}
#	)
#	$RandomSpawnTimer.wait_time = randf_range(1, 3)
#	$RandomSpawnTimer.start()
