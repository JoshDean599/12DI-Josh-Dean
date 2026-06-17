extends Node2D

var scoreLabel = null


func _on_tree_entered() -> void: # Happens before @onready is called
	if not scoreLabel:
		scoreLabel = $UI/Control/HBoxContainer/MarginContainer/Label
	
	reset_game()

func reset_game() -> void:
	pause_game()
	Globals.gameBufferTime = DisplayServer.screen_get_size().x / Globals.noteMoveSpeed
	Globals.gameTime = 0.0 - Globals.gameBufferTime
	Globals.gameScore = 0
	scoreLabel.text = "Score: 0"
	
	var noteHandler = $NoteHandler
	noteHandler.load_song(Globals.loadedSong)
	$SongHandler.load_song(Globals.loadedSong)
	
	for i in noteHandler.get_node("Notes").get_children().size():
		noteHandler.get_node("Notes").get_child(i).queue_free()
	noteHandler.noteQueue = []
	
	await get_tree().create_timer(.01).timeout
	play_game()


func pause_game() -> void:
	Globals.gamePlaying = false
	$SongHandler.get_node("Audio").stop()


func play_game() -> void:
	Globals.gamePlaying = true
	$SongHandler.get_node("Audio").play()


func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)


func incriment_score(value: int) -> void:
	Globals.gameScore += value
	scoreLabel.text = "Score: " + str(Globals.gameScore)


func _process(delta: float) -> void:
	if Globals.gamePlaying:
		Globals.gameTime += delta # Increase the time with delta
	
