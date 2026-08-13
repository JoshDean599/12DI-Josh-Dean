extends Node2D

var currentSong := ""
var time : float = 0.0

func _on_button_pressed() -> void:
	pause()
	get_parent().change_scene("SongSelectMenu")

func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0).timeout
		print(currentSong)
		play()
	

func play():
	$NoteHandler.active = true
	$NoteHandler.load_song()

func pause():
	$NoteHandler.active = false

func finish():
	print("finish")
	await get_tree().create_timer(2).timeout
	get_parent().change_scene("SongSelectMenu")
