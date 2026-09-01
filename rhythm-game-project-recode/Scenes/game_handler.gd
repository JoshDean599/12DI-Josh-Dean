extends Node2D
# Contains functions used by multiple scripts
@onready var currentScene = $MainMenu
const MapPath = "res://LoadedMaps/"

var noteMoveSpeed = 250 # Pixels a second
var YCollumnHeight = 10
var map = null

func _ready() -> void:
	# Make sure everything is hidden, apart from the starting scene
	for i in get_children():
		if i == currentScene:
			set_scene_visible(i, true)
			continue
		set_scene_visible(i, false)

func change_scene(scene: String):
	set_scene_visible(currentScene, false)
	var newScene = get_node(scene)
	set_scene_visible(newScene, true)
	currentScene = newScene

func set_scene_visible(scene, type: bool) -> void:
	scene.visible = type
	if scene.find_child("CanvasLayer"):
		scene.get_node("CanvasLayer").visible = type
	scene.set_process(type)

func load_map(MapName) -> Dictionary:
	var mapLocation = MapPath + MapName + ".json"
	if not FileAccess.open(mapLocation, FileAccess.READ): # If map can't be loaded: Return
		push_error("Map can't be found, Returning")
		return {}
	map = JSON.parse_string(FileAccess.get_file_as_string(mapLocation))
	return map

func get_file_list(FolderPath) -> Array:
	var list = []
	
	var dir = DirAccess.open(FolderPath)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if not dir.current_is_dir():
				list.push_back(fileName)
			fileName = dir.get_next()
	else:
		print("An error has occured when trying to access the path")
	
	return list

func remove_file_name_type(fileName: String, type: String) -> String:
	var newName = ""
	for character in fileName:
		if newName.length() < fileName.length() - type.length():
			newName = newName + character
		elif newName + type != fileName:
			return "" # Other type specified than what's within the fileName
	return newName
