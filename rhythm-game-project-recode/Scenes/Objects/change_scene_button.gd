extends Button
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@onready var gameHandler = get_tree().current_scene
@onready var songSelectMenu = gameHandler.get_node("SongSelectMenu")
@export var target: String
var difficulty: String = "Normal"

func _on_pressed() -> void:
	if target == "SongSelectMenu" and gameHandler.get_node("Game").visible: # Come back to later <--
		gameHandler.get_node("Game").pause() # Pause the game if leaving to the songSelectMenu
	elif songSelectMenu.visible: # When leaving the songSelectMenu:
		if target == "Game":
			gameHandler.load_map(songSelectMenu.SelectedSong, songSelectMenu.SelectedDifficulty)
			if gameHandler.map == {}:
				print("Map wasn't found, stopping")
				return
		elif target == "Editor":
			gameHandler.get_node("Editor").load_map(songSelectMenu.SelectedSong, songSelectMenu.SelectedDifficulty)
			pass
	gameHandler.change_scene(target)
