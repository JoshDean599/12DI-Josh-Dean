extends Node2D

var notes = {}
const NoteReference = preload("res://Scenes/Note.tscn")
@export var song = Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass

func create_new_note():
	notes[notes.size()+1] = NoteReference.instantiate()
	add_child(notes[notes.size()])
