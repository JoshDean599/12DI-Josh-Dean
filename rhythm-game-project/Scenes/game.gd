extends Node2D

# Handles Game logic

@onready var gameReady = false
@onready var scoreLabel = $UI/Control/HBoxContainer/MarginContainer/Label
@onready var noteHandler = $NoteHandler
@onready var songHandler = $SongHandler
var score = 0

func _on_tree_entered() -> void: # Happens before @onready is called
	if not gameReady:
		await ready
		gameReady = true
	reset_game(Globals.current_song) # Only reset game once ready
	

func reset_game(song) -> void:
	score = 0
	scoreLabel.text = "Score: 0"
	
	noteHandler.active = false
	songHandler.load_map(song)
	noteHandler.on_load(songHandler.map)
	
	for i in noteHandler.get_node("Notes").get_children().size():
		noteHandler.get_node("Notes").get_child(i).queue_free()
	noteHandler.noteQueue = []
	
	await buffer()
	play_game()

func buffer() -> void:
	await get_tree().create_timer(.01).timeout

func pause_game() -> void:
	songHandler.stop_song()

func play_game() -> void:
	var startTime = DisplayServer.window_get_size().x / noteHandler.noteMoveSpeed + 1 - songHandler.map.bufferTime
	if startTime < 0:
		startTime = 0
	songHandler.play_song(-startTime)
	await buffer()
	noteHandler.active = true


func _on_button_pressed() -> void: # Return button - Change name to fit
	Globals.change_scene(Globals.SongSelectMenu)


func incriment_score(value: int) -> void:
	score += value
	scoreLabel.text = "Score: " + str(score)
