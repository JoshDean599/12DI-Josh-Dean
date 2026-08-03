extends Sprite2D

@onready var songHandler = get_parent().get_node("SongHandler")
var loadedSong = null
var active = false
var noteMoveSpeed = 500

var noteQueue = [] #  Keeps track of what notes to process first
var heldKeys = [] # Keeps track of the held keys
var holding = false

var scores = {
	Perfect = {
		min = .06,
		max = .06,
		score = 100
	},
	Good = {
		min = 0.15,
		max = 0.15,
		score = 50
	},
	Ok = {
		min = 0.25,
		max = 0.25,
		score = 25
	},
	Bad = {
		min = 0.5,
		max = 0.5,
		score = 10
	},
	Miss = {
		min = 1,
		max = 1,
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
			
			if noteQueue.size() > 0 and noteQueue.front().noteTime < songHandler.trueTime + scores.Miss.max:
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
	if not active:
		return
	$Notes.position.x = -noteMoveSpeed * songHandler.trueTime
	
	# Remove from noteqQueue if passed point of hitting
	if noteQueue.size() > 0 and noteQueue.front().noteTime <= songHandler.trueTime - scores.Miss.min:
		print("Popped note")
		noteQueue.pop_front()
	
	if loadedSong != null:
		if loadedSong.Notes.size() > 0: # If a song is loaded and there's still notes to load
			check_note()
		elif noteQueue.size() == 0 and $Notes.get_children().size() == 0:
			# Song Ended
			active = false
			print("Finish")
			await get_tree().create_timer(2).timeout
			# Create a song end title card
			Globals.change_scene(Globals.SongSelectMenu)


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
	
