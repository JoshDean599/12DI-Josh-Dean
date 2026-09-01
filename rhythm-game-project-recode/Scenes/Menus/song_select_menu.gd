extends Node2D

var songSelectButton = preload("res://Scenes/Objects/song_select_button.tscn")

@onready var songList = $MarginContainer/VBoxContainer/VBoxContainer

func _on_visibility_changed() -> void:
	if visible: # The scene became the current
		load_maps()

func _on_back_pressed() -> void:
	get_parent().change_scene("MainMenu")

func load_maps() -> void:
	# Clear the songList
	for i in songList.get_children():
		i.queue_free()
	
	# Get the map names
	var mapNames = get_parent().get_file_list(get_parent().MapPath)
	# Create a button for each of the maps
	for mapName in mapNames:
		mapName = get_parent().remove_file_name_type(mapName, ".json")
		if mapName == "": # Discard if it the mapName isn't from a json file
			continue
		# Create a button leading to the map
		var newButton = songSelectButton.instantiate()
		newButton.get_node("HBoxContainer/Button").text = mapName
		songList.add_child.call_deferred(newButton)
