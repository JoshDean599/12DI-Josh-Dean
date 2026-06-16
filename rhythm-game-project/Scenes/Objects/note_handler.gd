extends Sprite2D

var loadedSong = null

var noteQueue = [] #  Keeps track of what notes to process first
var heldKeys = [] # Keeps track of the held keys
var holding = false

var scores = {
	perfect = {
		range = .05,
		score = 100
	},
	miss = {
		range = .3,
		score = 0
	}
}


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			if heldKeys.find(event.keycode) == -1:
				heldKeys.push_back(event.keycode)
			
			if noteQueue.size() > 0 and noteQueue.front().position.x < 250: # Change to a proper range
				var noteIndexToPop = noteQueue.pop_front()
				noteIndexToPop.active = true
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
	$Notes.position.x = -Globals.noteMoveSpeed * Globals.gameTime
	
	# Remove from noteqQueue if passed point of hitting
	if noteQueue.size() > 0 and noteQueue.front().noteTime <= Globals.gameTime: # Change to proper range
		print("Disable note")
		noteQueue.pop_front().visible = false
	
	if loadedSong != null and loadedSong.Notes.size() > 0: # If a song is loaded and there's still notes to load
		check_note()
	
	


func create_note(noteSettings: Dictionary) -> void:
	print("CreateNote")
	noteSettings.position.x = Globals.noteMoveSpeed * noteSettings.time
	var noteInstance = Globals.GameNote.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteInstance.setup(self, noteSettings)
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)


func load_song(song):
	loadedSong = Globals.load_song(Globals.mapPath + song + ".json")


func check_note():
	var closestNote = 0 # Index of closest note
	var currentIndex = 0
	for i in loadedSong.Notes:
		if loadedSong.Notes[currentIndex].time < loadedSong.Notes[closestNote].time:
			closestNote = currentIndex
		currentIndex += 1
	
	if loadedSong.Notes[closestNote].time - DisplayServer.screen_get_size().x / Globals.noteMoveSpeed <= Globals.gameTime:
		create_note(loadedSong.Notes.pop_at(closestNote))
	
