extends Node2D

# Handles Game logic

@onready var gameReady = true
@onready var scoreLabel = $UI/Control/HBoxContainer/MarginContainer/Label
@onready var noteHandler = $NoteHandler
@onready var songHandler = $SongHandler
var score = 0

func _on_tree_entered() -> void: # Happens before @onready is called
	if not gameReady:
		await ready
	reset_game("new") # Only reset game once ready -- Create way to dynamically open different songs
	

func reset_game(song) -> void:
	score = 0
	scoreLabel.text = "Score: 0"
	
	noteHandler.active = false
	songHandler.load_map(song)
	noteHandler.on_load(songHandler.map)
	
	for i in noteHandler.get_node("Notes").get_children().size():
		noteHandler.get_node("Notes").get_child(i).queue_free()
	noteHandler.noteQueue = []
	
	await get_tree().create_timer(.01).timeout
	play_game()


func pause_game() -> void:
	songHandler.stop_song()

func play_game() -> void:
	songHandler.play_song(-5.0)
	noteHandler.active = true


func _on_button_pressed() -> void: # Return button - Change name to fit
	Globals.change_scene(Globals.MainMenu)


func incriment_score(value: int) -> void:
	score += value
	scoreLabel.text = "Score: " + str(score)
