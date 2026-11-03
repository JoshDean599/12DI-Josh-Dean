extends Node2D

@onready var HitMarker = $HitMarker
@onready var note = preload("res://Scenes/Objects/game_note.tscn")

var paused = false
var loadedMap = null
var noteQueue = []
var holdNoteQueue = []
var releaseNoteQueue = [] # Inactive for now
var heldKeys = []

var currentScore = 0

var time = -2 # How long the song has played for

func _ready() -> void:
	loadedMap = FileHandler.get_map(GameData.SelectedMap, GameData.SelectedDifficulty)
	$CanvasLayer/PauseMenu.visible = false
	time = -2 + loadedMap.bufferTime
	if time > 0:
		time = 0
	$MusicPlayer.play_at(time)

func start():
	paused = false
	$CanvasLayer/PauseMenu.visible = false
	$MusicPlayer.play_at(time)

func stop():
	paused = true
	$CanvasLayer/PauseMenu.visible = true
	$MusicPlayer.pause()

func finish():
	paused = true
	$MusicPlayer.pause()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/song_select.tscn")

func set_time(newTime: float):
	time = newTime

func _process(delta: float) -> void:
	if paused or loadedMap == null:
		return
	time += delta # Update the time
	
	if loadedMap.Notes.size() > 0:
		if loadedMap.Notes.front().StartTime - float(DisplayServer.screen_get_size().x) / GameData.NoteSpeed <= time:
			create_note(loadedMap.Notes.pop_front())
	elif not noteQueue.size() and $Notes.get_children().size() == 0:
			# Song Ended
			finish()

func create_note(noteSettings: Dictionary):
	var noteInstance = note.instantiate()
	noteInstance.set_times(noteSettings)
	$Notes.call_deferred("add_child", noteInstance)
	
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)

# Handle Note presses
func _unhandled_input(event: InputEvent) -> void:
	if paused:
		return
	if not event.is_echo() and event is InputEventKey:
		if event.is_pressed():
			if heldKeys.find(event.keycode) == -1: # If the key press isn't found to be already pressing:
				heldKeys.push_back(event.keycode) # Add it to the list of pressed keys
			
			if not noteQueue.is_empty() and noteQueue.front().StartTime - .5 < time:
				noteQueue.pop_front().check_hit()
			
		elif event.is_released():
			if heldKeys.find(event.keycode) >= 0:
				heldKeys.pop_at(heldKeys.find(event.keycode))
		
		if heldKeys.is_empty():
			while len(holdNoteQueue) > 0: # Flush out the held notes as no keys are held
				holdNoteQueue.pop_front().check_hit()

func update_score(score):
	currentScore += score
	$CanvasLayer/MarginContainer/HBoxContainer/Score.text = str(currentScore)

func _on_pause_button_pressed() -> void:
	stop()

func _on_continue_button_pressed() -> void:
	start()

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/song_select.tscn")
