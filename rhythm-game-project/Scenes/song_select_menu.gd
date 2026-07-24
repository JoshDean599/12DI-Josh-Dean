extends Node2D

var gameReady = false
var maps = "res://Songs/Maps"
var button = preload("res://Scenes/Objects/song_select_button.tscn")
@onready var vbox = $UI/VBoxContainer/VBoxContainer

func _on_tree_entered() -> void:
	if not gameReady:
		await ready
		gameReady = true
	
	refresh()

func refresh():
	# Clear the vBoxContainer
	for i in vbox.get_children().size():
		vbox.get_child(i).queue_free()
	
	dir_contents(maps)

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				var new_file_name = ""
				for i in file_name:
					if new_file_name.length() < file_name.length() - 5:
						new_file_name = new_file_name + i
				
				var newButton = button.instantiate()
				newButton.get_node("HBoxContainer/Button").text = new_file_name
				vbox.add_child(newButton)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_button_pressed() -> void:
	Globals.change_scene(Globals.MainMenu)
