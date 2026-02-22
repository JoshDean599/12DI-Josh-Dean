extends Node2D

var notes = {}
const note = preload("res://Scenes/Note.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	create_note()
	print(notes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_note():
	notes[notes.size() + 1] = note.instantiate()
	add_child(notes[notes.size()])


func deactivate_note():
	pass
