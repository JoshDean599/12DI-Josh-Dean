extends Node2D

var currentSong = "new"

var scoreLabel = null
var noteHandler = null
var songHandler = null

var currentScore: int = 0
var currentTime: float = 0.0
var bufferTime: float = 2.0 # Time until game starts so it doesn't start instantly

var playing = false


func _on_tree_entered() -> void: # Happens before @onready is called
	if not scoreLabel:
		scoreLabel = $UI/Control/HBoxContainer/MarginContainer/Label
	if not noteHandler:
		noteHandler = $NoteHandler
	if not songHandler:
		songHandler = $SongHandler
	
	# Reset the game on re-load
	# Reset the score:
	currentScore = 0
	# Reset the time:
	currentTime = 0.0
	# Reset the score label
	scoreLabel.text = "Score: 0"
	
	songHandler.get_node("Audio").stop()
	playing = false
	
	for i in noteHandler.get_node("Notes").get_children().size():
		noteHandler.get_node("Notes").get_child(i).queue_free()
	noteHandler.noteQueue = []


func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func incriment_score(value: int) -> void:
	currentScore += value
	scoreLabel.text = "Score: " + str(currentScore)


func _process(delta: float) -> void:
	currentTime += delta # Increase the time with delta
	
	if not playing and currentTime - bufferTime >= 0:
		playing = true
		noteHandler.load_song(currentSong)
		songHandler.load_song(currentSong)
		songHandler.get_node("Audio").play()
	
	
