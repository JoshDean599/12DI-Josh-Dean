extends Node2D

@onready var HitMarker = $HitMarker
@onready var note = preload("res://NewScenes/Objects/game_note.tscn")

signal pressedKey
signal releasedKey
signal stoppedHolding

var paused = false
var loadedMap = null
var noteQueue = []
var heldKeys = []
var foundNextNoteIndex = -1
var noteSpeed = 700 # Maybe change it so each note has it's own speed?

var time = -2 # How long the song has played for

func _ready() -> void:
	loadedMap = FileHandler.get_map(GameData.SelectedMap, GameData.SelectedDifficulty)

func start():
	paused = false

func stop():
	paused = true

func finish():
	stop()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://NewScenes/song_select.tscn")

func set_time(newTime: float):
	time = newTime

func _process(delta: float) -> void:
	if paused or loadedMap == null:
		return
	time += delta # Update the time
	
	if loadedMap.Notes.size() > 0:
		check_note() # Check for the notes to spawn in
	elif not noteQueue.size() and $Notes.get_children().size() == 0:
			# Song Ended
			finish()

func check_note():
	if foundNextNoteIndex == -1:
		foundNextNoteIndex = 0 # Index of closest note
		var currentIndex = 0
		
		for i in loadedMap.Notes:
			if loadedMap.Notes[currentIndex].time < loadedMap.Notes[foundNextNoteIndex].time:
				foundNextNoteIndex = currentIndex
			currentIndex += 1
	
	if loadedMap.Notes[foundNextNoteIndex].time - float(DisplayServer.screen_get_size().x) / noteSpeed <= time:
		create_note(loadedMap.Notes.pop_at(foundNextNoteIndex))
		foundNextNoteIndex = -1

func create_note(noteSettings: Dictionary):
	var noteInstance = note.instantiate()
	noteInstance.settings = noteSettings
	$Notes.call_deferred("add_child", noteInstance)
	
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)

# Handle Note presses
func _unhandled_input(event: InputEvent) -> void:
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			pressedKey.emit()
			if heldKeys.find(event.keycode) == -1: # If the key press isn't found to be already pressing:
				heldKeys.push_back(event.keycode) # Add it to the list of pressed keys
		elif event.is_released():
			releasedKey.emit()
			if heldKeys.find(event.keycode) >= 0:
				heldKeys.pop_at(heldKeys.find(event.keycode))
		
		# Update holding:
		if heldKeys.size():
			stoppedHolding.emit()
