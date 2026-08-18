extends PanelContainer

func _ready() -> void:
	$HBoxContainer/MenuButton.get_popup().connect("index_pressed", on_press)

func _on_button_pressed() -> void:
	if get_tree().current_scene.get_node("SongSelectMenu").visible:
		get_tree().current_scene.change_scene("Game")
		get_tree().current_scene.get_node("Game").currentSong = $HBoxContainer/Button.text
	else:
		print("hi")
	

func on_press(index):
	if index == 0:
		if get_tree().current_scene.get_node("SongSelectMenu").visible:
			DirAccess.remove_absolute(get_tree().current_scene.MapPath + $HBoxContainer/Button.text + ".json")
			get_tree().current_scene.get_node("SongSelectMenu").load_songs()
		else:
			print("Hi")
