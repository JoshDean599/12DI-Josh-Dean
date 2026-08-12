extends Node2D

var currentSong = ""

func _on_button_pressed() -> void:
	get_parent().change_scene("SongSelectMenu")
	pass # Replace with function body.

func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0).timeout
		print(currentSong)
		play()
	pass # Replace with function body.

func play():
	$NoteHandler.active = true
	pass

func pause():
	$NoteHandler.active = false
	pass
