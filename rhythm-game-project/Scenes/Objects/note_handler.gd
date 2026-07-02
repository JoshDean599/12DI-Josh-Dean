extends Sprite2D

@onready var songHandler = get_parent().get_node("SongHandler")
var loadedSong = null
var active = false
var noteMoveSpeed = 250

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

func on_load(map):
	loadedSong = map

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			if heldKeys.find(event.keycode) == -1: # If the key press isn't found to be already pressing:
				heldKeys.push_back(event.keycode) # Add it to the list of pressed keys
			
			if noteQueue.size() > 0 and noteQueue.front().noteTime < songHandler.trueTime + 1: # Change to a proper range
				noteQueue.pop_front().active = true
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
	if not active: return
	$Notes.position.x = -noteMoveSpeed * songHandler.trueTime
	
	# Remove from noteqQueue if passed point of hitting
	if noteQueue.size() > 0 and noteQueue.front().noteTime <= songHandler.trueTime: # Change to proper range
		print("Popped note")
		noteQueue.pop_front()
	
	if loadedSong != null and loadedSong.Notes.size() > 0: # If a song is loaded and there's still notes to load
		check_note()


func create_note(noteSettings: Dictionary) -> void:
	var noteInstance = Globals.GameNote.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteInstance.setup(self, noteSettings)
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)


func check_note():
	var closestNote = 0 # Index of closest note
	var currentIndex = 0
	for i in loadedSong.Notes:
		if loadedSong.Notes[currentIndex].time < loadedSong.Notes[closestNote].time:
			closestNote = currentIndex
		currentIndex += 1
	
	if loadedSong.Notes[closestNote].time - float(DisplayServer.screen_get_size().x) / noteMoveSpeed <= songHandler.trueTime:
		create_note(loadedSong.Notes.pop_at(closestNote))
	
