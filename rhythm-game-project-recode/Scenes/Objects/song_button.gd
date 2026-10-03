extends Button

@onready var SongSelectMenu = get_tree().current_scene.get_node("SongSelectMenu")
var isSongButton := true

func _on_pressed() -> void:
	if isSongButton:
		SongSelectMenu.SongSelected(self.text)
		if SongSelectMenu.SelectedSongButton != null:
			SongSelectMenu.SelectedSongButton.deselect()
		SongSelectMenu.SelectedSongButton = self
	else:
		SongSelectMenu.SelectedDifficulty = self.text
		if SongSelectMenu.SelectedDifficultyButton != null:
			SongSelectMenu.SelectedDifficultyButton.deselect()
		SongSelectMenu.SelectedDifficultyButton = self
	select()

func select() -> void:
	self.modulate = Color.BLUE_VIOLET # PlaceHolder effects to show the button is selected
	pass

func deselect() -> void:
	self.modulate = Color.WHITE # Undoes what effects select() does
	pass
