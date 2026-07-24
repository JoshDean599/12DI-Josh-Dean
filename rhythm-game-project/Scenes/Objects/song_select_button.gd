extends PanelContainer

func _on_button_pressed() -> void:
	Globals.start_game($HBoxContainer/Button.text)


func _ready() -> void:
	$HBoxContainer/Options.get_popup().connect("index_pressed", onpress)

func onpress(index):
	if index == 0:
		DirAccess.remove_absolute("res://Songs/Maps/" + $HBoxContainer/Button.text + ".json")
		
		get_parent().get_parent().get_parent().get_parent().refresh()
