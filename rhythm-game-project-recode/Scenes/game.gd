extends Node2D

@onready var timeHandler = $TimeHandler
var currentSong := ""
var score = 0
var active = false

func _on_button_pressed() -> void:
	pause()
	get_parent().change_scene("SongSelectMenu")

func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0).timeout
		get_tree().current_scene.load_map(currentSong)
		score = 0
		timeHandler.reset()
		incriment_score(0)
		play()

func play():
	timeHandler.play()
	$NoteHandler.active = true
	$NoteHandler.load_song()

func pause():
	timeHandler.pause()
	$NoteHandler.active = false

func finish():
	print("finish")
	var finishTime = 2
	timeHandler.finish(finishTime)
	await get_tree().create_timer(finishTime).timeout
	get_parent().change_scene("SongSelectMenu")

func incriment_score(Score):
	score += Score
	$CanvasLayer/HBoxContainer/Label.text = "Score: " + str(score)
	pass
