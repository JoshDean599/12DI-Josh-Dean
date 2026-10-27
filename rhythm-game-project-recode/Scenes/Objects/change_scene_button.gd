extends Button
@onready var SongSelectMenu = get_tree().current_scene.get_node("SongSelectMenu")
@export var target: String

func _on_pressed() -> void:
	if target == "Game" or target == "Editor":
		if not SongSelectMenu.SelectedSongButton or not SongSelectMenu.SelectedDifficultyButton:
			return
	get_tree().current_scene.change_scene(target)
