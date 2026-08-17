extends Node2D

var currentSong := ""
var time : float = 0.0
var score = 0
var active = false

func _on_button_pressed() -> void:
	pause()
	get_parent().change_scene("SongSelectMenu")

func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0).timeout
		score = 0
		time = 0.0
		incriment_score(0)
		play()

func play():
	active = true
	$NoteHandler.active = true
	$NoteHandler.load_song()

func pause():
	active = false
	$NoteHandler.active = false

func finish():
	print("finish")
	await get_tree().create_timer(2).timeout
	get_parent().change_scene("SongSelectMenu")

func _process(delta: float) -> void:
	if active:
		time += delta

func incriment_score(Score):
	score += Score
	$CanvasLayer/HBoxContainer/Label.text = "Score: " + str(score)
	pass
