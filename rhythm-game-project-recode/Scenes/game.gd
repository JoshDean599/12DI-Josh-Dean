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
		incriment_score(0)
		play()

func play():
	var startTime = DisplayServer.window_get_size().x / get_parent().noteMoveSpeed - get_parent().map.bufferTime + 1
	if startTime < 0:
		startTime = 0
	timeHandler.play(-startTime)
	$NoteHandler.active = true
	$NoteHandler.load_song()

func pause():
	timeHandler.pause()
	$NoteHandler.active = false

func incriment_score(Score):
	score += Score
	$CanvasLayer/HBoxContainer/Label.text = "Score: " + str(score)
	pass
