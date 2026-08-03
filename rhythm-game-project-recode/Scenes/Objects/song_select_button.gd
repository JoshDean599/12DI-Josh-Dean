extends PanelContainer

func _ready() -> void:
	$HBoxContainer/MenuButton.get_popup().connect("index_pressed", onpress)

func _on_button_pressed() -> void:
	print("StartSong: ", $HBoxContainer/Button.text)

func onpress(index):
	if index == 0:
		DirAccess.remove_absolute(get_tree().MapPath + $HBoxContainer/Button.text + ".json")
		get_parent().load_songs()
