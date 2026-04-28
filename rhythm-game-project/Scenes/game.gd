extends Node2D

var currentScore = 0

func _on_tree_entered() -> void:
	# Reset the game on re-load
	incriment_score(0)
	for i in $Notes.get_children().size():
		$Notes.get_child(i).queue_free()
	$NoteHandler.noteQueue = []

func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)

func incriment_score(value) -> void:
	currentScore += value
	$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: " + str(currentScore)
	if value == 0: # Reset the score
		$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: 000"
