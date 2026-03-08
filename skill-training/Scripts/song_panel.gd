extends PanelContainer

var song = ""

func set_new_name(newName):
	name = newName
	$Button/MarginContainer/HBoxContainer/Label.text = newName

func set_song(setSong):
	song = setSong

func _on_button_pressed() -> void:
	if song != "":
		print("EnterSong")
	else:
		print("Failed to set song")
