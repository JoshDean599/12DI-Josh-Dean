extends Node2D

var gameNote = preload("res://Scenes/Objects/game_note.tscn")

var loadedSong = null
var active = false

var noteQueue := []
var heldKeys := []
var holding := false

func load_song():
	loadedSong = get_tree().current_scene.load_map(get_parent().currentSong)
	print(loadedSong)
	pass

func _process(_delta: float) -> void:
	if not active:
		return
	
	if loadedSong != null:
		if loadedSong.Notes.size() > 0: # If a song is loaded and there's still notes to load
			check_note()
		elif noteQueue.size() == 0 and $Notes.get_children().size() == 0:
			# Song Ended
			active = false
			print("Finish")
			await get_tree().create_timer(2).timeout
			# Create a song end title card
			#Globals.change_scene(Globals.SongSelectMenu)

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
	noteInstance.setup(self, noteSettings)
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)
