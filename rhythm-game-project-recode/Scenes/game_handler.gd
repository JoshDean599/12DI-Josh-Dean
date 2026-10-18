extends Node2D
# Contains functions used by multiple scripts
@onready var currentScene = $MainMenu
const MapPath = "res://LoadedMaps/"
const SongMapPathName = "SongMaps"
const SongMusicPathName = "LoadedSongs"
var SongMapDirPath = OS.get_user_data_dir() + "/" + SongMapPathName
var SongMusicDirPath = OS.get_user_data_dir() + "/" + SongMusicPathName

var noteMoveSpeed = 1000 # Pixels a second
var YCollumnHeight = 10
var map = null

func _ready() -> void:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(SongMapPathName):
		dir.make_dir(SongMapPathName)
	if not dir.dir_exists(SongMusicPathName):
		dir.make_dir(SongMusicPathName)
	#AudioStreamMP3.load_from_file("")
	
	# Make sure everything is hidden, apart from the starting scene
	for i in get_children():
		if i == currentScene:
			set_scene_visible(i, true)
			continue
		set_scene_visible(i, false)

func change_scene(scene: String):
	var newScene = get_node(scene)
	if not newScene:
		print("Failed to changeScene, scene not found")
		return
	set_scene_visible(currentScene, false)
	set_scene_visible(newScene, true)
	currentScene = newScene

func set_scene_visible(scene, type: bool) -> void:
	if scene.find_child("CanvasLayer"):
		scene.get_node("CanvasLayer").visible = type
		scene.get_node("CanvasLayer").set_process(type)
	scene.visible = type
	scene.set_process(type)

func load_map(MapName, Difficulty) -> Dictionary:
	var mapLocation = SongMapDirPath + "/" + MapName + "/" + Difficulty
	if not FileAccess.open(mapLocation, FileAccess.READ):
		print("Failed to open the map file, returning empty")
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
			list.push_back(fileName)
			fileName = dir.get_next()
	
	return list

func remove_file_name_type(fileName: String, type: String) -> String:
	var newName = ""
	for character in fileName:
		if newName.length() < fileName.length() - type.length():
			newName = newName + character
		elif newName + type != fileName:
			return "" # Other type specified than what's within the fileName
	return newName

func create_folder(folderPath: String, folderName: String):
	var dir = DirAccess.open(folderPath)
	if not dir:
		print("Folder Path Not Found: Returning")
		return
	var extra = 1
	if dir.dir_exists(folderName): # Make sure the folder name is unique
		while dir.dir_exists(folderName + str(extra)):
			extra += 1
		folderName += str(extra)
	dir.make_dir(folderPath + "/" + folderName)
	return folderName

func create_or_modify_file(filePath: String, fileName: String, fileContents : Dictionary):
	var newFileName = remove_file_name_type(fileName, ".json")
	if newFileName != "":
		fileName = newFileName
	var dir = DirAccess.open(filePath)
	if not dir:
		print("File location: " + filePath + " was unable to be found: Returning")
		return
	var extra = 1
	if dir.file_exists(fileName + ".json"):
		while dir.file_exists(fileName + str(extra) + ".json"):
			extra += 1
		fileName += str(extra)
	var file = FileAccess.open(dir.get_current_dir() + "/" + fileName + ".json", FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(JSON.stringify(fileContents, "\t"))
	else:
		print("File: " + fileName +" was unable to be created or modified: Returning")
		return
	return newFileName
