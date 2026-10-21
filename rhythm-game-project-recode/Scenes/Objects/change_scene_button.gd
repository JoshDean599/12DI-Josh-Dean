extends Button
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@onready var gameHandler = get_tree().current_scene
@onready var songSelectMenu = gameHandler.get_node("SongSelectMenu")
@export var target: String

func _on_pressed() -> void:
	if target == "SongSelectMenu" and gameHandler.get_node("Game").visible: # Come back to later <--
		gameHandler.get_node("Game").pause() # Pause the game if leaving to the songSelectMenu
	elif songSelectMenu.visible: # When leaving the songSelectMenu:
		if target == "Editor":
			if not songSelectMenu.SelectedSongButton or not songSelectMenu.SelectedDifficultyButton: return
			gameHandler.get_node("Editor").load_map(songSelectMenu.SelectedSongButton.text, songSelectMenu.SelectedDifficultyButton.text)
	gameHandler.change_scene(target)
