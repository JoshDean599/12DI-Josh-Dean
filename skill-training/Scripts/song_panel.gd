extends PanelContainer

@onready var gameHandler = get_tree().root.get_node("GameHandler")
var song = ""

func set_new_name(newName):
	$Button/MarginContainer/HBoxContainer/Label.text = newName

func set_song(setSong):
	if setSong == "":
		print("Failed to set Song")
	else:
		song = setSong

func _on_button_pressed() -> void:
	gameHandler.song = song
	gameHandler.change_scene("SongSelectMenu", "Game")
