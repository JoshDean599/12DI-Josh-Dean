extends Control

var songPanel = preload("res://Scenes/song_panel.tscn")

func _on_back_button_pressed() -> void:
	get_parent().change_scene(name, "MainMenu")

func _on_visibility_changed() -> void:
	if visible:
		var dir = DirAccess.open("res://SongMaps/")
		if dir:
			dir.list_dir_begin()
			var fileName = dir.get_next()
			while fileName != "":
				if dir.current_is_dir():
					print("foundDirectery")
				else:
					print("FoundFile")
					var stopLoop
					for i in fileName:
						if i = ".":
							
					var withoutJson = ""
					if $Songs.get_node("" + fileName):
						continue
					var newSongPanel = songPanel.instantiate()
					$Songs.add_child(newSongPanel)
					newSongPanel.set_new_name(fileName)
					newSongPanel.set_song("res://SongMaps/" + fileName)
				fileName = dir.get_next()
		else:
			print("Couldn't access the path")
