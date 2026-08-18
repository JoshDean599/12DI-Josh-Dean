extends Node2D

var songSelectButton = preload("res://Scenes/Objects/song_select_button.tscn")


func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		load_songs()

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func load_songs() -> void:
	# Remove any songs that are loaded
	for i in $VBoxContainer/VBoxContainer.get_children():
		i.queue_free()
	
	var dir = DirAccess.open(get_parent().MapPath)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				var newFileName = ""
				for i in fileName:
					if newFileName.length() < fileName.length() - 5:
						newFileName = newFileName + i
				
				var newButton = songSelectButton.instantiate()
				newButton.get_node("HBoxContainer/Button").text = newFileName
				$VBoxContainer/VBoxContainer.add_child.call_deferred(newButton)
				
			fileName = dir.get_next()
	else:
		print("An error has occured when trying to access the path")
