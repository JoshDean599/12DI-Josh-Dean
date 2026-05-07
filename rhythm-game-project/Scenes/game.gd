extends Node2D

var currentScore: int = 0
var currentTime: float = 0.0

var scores = { # Maybe change the position of this to Globals
	ok = { #-- WHY IS THIS A STRING????
		lower = -.5,
		upper = .5,
		score = 50
	},
	perfect = {
		lower = -.1,
		upper = .1,
		score = 200
	}
}

func _on_tree_entered() -> void:
	# Reset the game on re-load
	# Reset the score:
	currentScore = 0
	# Reset the time:
	currentTime = 0.0
	
	$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: 0"
	# Remove all loaded notes from the scene and queue:
	for i in $Notes.get_children().size():
		$Notes.get_child(i).queue_free()
	$NoteHandler.noteQueue = []

func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)

func incriment_score(value: int) -> void:
	currentScore += value
	$UI/Control/HBoxContainer/MarginContainer/Label.text = "Score: " + str(currentScore)


func _process(delta: float) -> void:
	currentTime += delta
	#$Camera2D.position.x -= delta * 10 # - Move camera for some reason
	pass
