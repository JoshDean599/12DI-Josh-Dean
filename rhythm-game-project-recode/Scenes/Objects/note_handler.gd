extends Node2D

var gameNote = preload("res://Scenes/Objects/game_note.tscn")

var loadedSong = null
var active = false

var noteQueue := []
var heldKeys := []
var holding := false

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

func load_song():
	loadedSong = get_tree().current_scene.load_map(get_parent().currentSong)
	print(loadedSong)
	for i in $Notes.get_children():
		i.free()
	noteQueue = []

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			if heldKeys.find(event.keycode) == -1: # If the key press isn't found to be already pressing:
				heldKeys.push_back(event.keycode) # Add it to the list of pressed keys
			
			if noteQueue.size() > 0 and noteQueue.front().settings.time < get_parent().time + scores.Miss.max:
				noteQueue.pop_front().active = true
		elif event.is_released():
			if heldKeys.find(event.keycode) >= 0:
				heldKeys.pop_at(heldKeys.find(event.keycode))
		
		# Update holding:
		if heldKeys.size():
			holding = true
		else:
			holding = false
	

func _process(_delta: float) -> void:
	if not active:
		return
	
	$Notes.position.x = -get_tree().current_scene.noteMoveSpeed * get_parent().time
	
	if loadedSong != null:
		if loadedSong.Notes.size() > 0: # If a song is loaded and there's still notes to load
			check_note()
		elif noteQueue.size() == 0 and $Notes.get_children().size() == 0:
			# Song Ended
			active = false
			print("Finish")
			await get_tree().create_timer(2).timeout
			# Create a song end title card
			get_tree().current_scene.change_scene("SongSelectMenu")

func check_note():
	var closestNote = 0 # Index of closest note
	var currentIndex = 0
	for i in loadedSong.Notes:
		if loadedSong.Notes[currentIndex].time < loadedSong.Notes[closestNote].time:
			closestNote = currentIndex
		currentIndex += 1
	
	if loadedSong.Notes[closestNote].time - float(DisplayServer.screen_get_size().x) / get_tree().current_scene.noteMoveSpeed <= get_parent().time:
		create_note(loadedSong.Notes.pop_at(closestNote))
	

func create_note(noteSettings: Dictionary) -> void:
	var noteInstance = gameNote.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteInstance.settings = noteSettings
	noteInstance.holdEndTime = noteSettings.time + noteSettings.tailTime
	
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)
