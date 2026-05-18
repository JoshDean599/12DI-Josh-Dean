extends Node2D

var currentScore: int = 0
var currentTime: float = 0.0


func _on_tree_entered() -> void:
	# Reset the game on re-load
	# Reset the score:
	currentScore = 0
	
	currentTime = 0.0
	
	$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: 0"
	# Remove all loaded notes from the scene and queue:
	for i in $NoteHandler.get_node("Notes").get_children().size():
		$NoteHandler.get_node("Notes").get_child(i).queue_free()
	$NoteHandler.noteQueue = []

func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)

func incriment_score(value: int) -> void:
	currentScore += value
	$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: " + str(currentScore)

func _process(delta: float) -> void:
	currentTime += delta
