extends Node2D

var gameReady = false
var maps = "res://Songs/Maps"

func _on_tree_entered() -> void:
	if not gameReady:
		await ready
		gameReady = true
	
	# Clear the vBoxContainer
	for i in $UI/VBoxContainer/VBoxContainer.get_children().size():
		$UI/VBoxContainer/VBoxContainer.get_child(i).queue_free()
	
	dir_contents(maps)

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				var new_file_name = ""
				for i in file_name:
					if new_file_name.length() < file_name.length() - 5:
						new_file_name = new_file_name + i
				
				var newButton = Button.new()
				newButton.text = new_file_name
				newButton.connect("pressed", on_select_button_pressed.bind(newButton))
				$UI/VBoxContainer/VBoxContainer.add_child(newButton)
				print("Found file: " + new_file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func on_select_button_pressed(Self) -> void:
	Globals.start_game(Self.text)
	pass


func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)
