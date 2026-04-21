extends Node2D

var Note = preload("res://Scenes/Objects/editor_note.tscn")

func _on_add_note_pressed() -> void:
	createNewNote()

func createNewNote() -> void:
	var newNote = Note.instantiate()
	$Notes.add_child(newNote)
	newNote.name = str($Notes.get_children().size())
