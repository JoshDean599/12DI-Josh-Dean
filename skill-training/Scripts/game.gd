extends Node2D

@onready var note = preload("res://Scenes/game_note.tscn")
var inactiveNotes = {}

func start_game(song: String) -> void:
	var songAsDict = JSON.parse_string(FileAccess.get_file_as_string(song))
	for i in songAsDict: # For each note in the song
		if inactiveNotes.size() < 1:
			create_new_note(Vector2(songAsDict[i].position.x, songAsDict[i].position.y), true, 25)
		pass

func _on_visibility_changed() -> void:
	if visible:
		start_game(get_parent().song)

func create_new_note(position: Vector2, active: bool, speed: float):
	var newNote = note.instantiate()
	$Notes.add_child(newNote)
	newNote.position = position
	newNote.active = active
	newNote.speed = speed
