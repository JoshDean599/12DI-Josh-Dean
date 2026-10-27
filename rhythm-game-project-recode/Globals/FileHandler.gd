extends Node

var SongFolderPathName = "SongMaps"
var SongFolderPath = OS.get_user_data_dir() + "/" + SongFolderPathName
var MusicPathName = "LoadedSongs"
var MusicFolderPath = OS.get_user_data_dir() + "/" + MusicPathName

func _ready() -> void:
	# Create the directories if not already created
	var dir = DirAccess.open("user://")
	if not dir.dir_exists(SongFolderPathName):
		dir.make_dir(SongFolderPathName)
	if not dir.dir_exists(MusicPathName):
		dir.make_dir(MusicPathName)

func load_file(JsonFileLocation: String) -> Dictionary:
	if not FileAccess.open(JsonFileLocation, FileAccess.READ):
		print("Failed to open the map file, returning empty")
		return {}
	return JSON.parse_string(FileAccess.get_file_as_string(JsonFileLocation))

func get_map(Map: String, Difficulty: String) -> Dictionary:
	if not Map or not Difficulty:
		print("Map or Difficulty not provided, returning empty")
		return {}
	return load_file(SongFolderPath + "/" + Map + "/" + Difficulty + ".json")

func get_properties(Map: String) -> Dictionary:
	if not Map:
		print("Map was not provided, returning empty")
		return {}
	return load_file(SongFolderPath + "/" + Map + "/Properties.json")

func make_unique(Name: String, Directory: DirAccess) -> String:
	var extra = 1
	if Directory.dir_exists(Name) or Directory.file_exists(Name + ".json"): # Check if the name already exists in the directory
		while Directory.dir_exists(Name + str(extra)) or Directory.file_exists(Name + str(extra) + ".json"):# If the name already exists: Check each re-occursior
			extra += 1 # Count each occursion
		Name += str(extra) # Set the name to the lowest occursion that doesn't exist
	return Name # Return the new name if it got modified

func split_file_name(path: String) -> Array:
	if len(path) == 0: # If there is no path to split, return empty
		return []
	var count = 0
	for i in path: # Find how long the fileName is:
		if path[len(path) - count - 1] == "/":
			break
		count += 1
	var fileName = ""
	for i in range(count): # Get the fileName:
		fileName += path[len(path) - count + i]
	var filePath = ""
	for i in range(len(path) - count - 1): # Get the filePath:
		filePath += path[i]
	return [filePath, fileName]

func remove_type(fileName: String, type: String) -> String:
	var newName = ""
	for character in fileName:
		if newName.length() < fileName.length() - type.length():
			newName = newName + character
		elif newName + type != fileName:
			return "" # Other type specified than what's within the fileName
	return newName

func create_folder(path: String):
	var folderName = split_file_name(path)
	if folderName == []: # If the path was unable to be split: return
		return
	var dir = DirAccess.open(folderName[0])
	if not dir: # If the directory was unable to be opened, return
		print("Folder Path, ", folderName[0], " was Not found, returning")
		return
	folderName[1] = make_unique(folderName[1], dir)
	dir.make_dir(folderName[0] + "/" + folderName[1])
	return folderName

func create_file(path: String, contents: Dictionary):
	make_file(path, contents, true)

func edit_file(path: String, contents: Dictionary):
	make_file(path, contents, false)

func make_file(path: String, contents : Dictionary, create: bool):
	var fileName = split_file_name(remove_type(path, ".json"))
	if fileName == []:
		return
	var dir = DirAccess.open(fileName[0])
	if not dir: # If the directory was unable to be opened, return
		print("File Path: ", fileName[0], " was not found, returning")
		return
	if create:
		fileName[1] = make_unique(fileName[1], dir)
	var file = FileAccess.open(fileName[0] + "/" + fileName[1] + ".json", FileAccess.ModeFlags.WRITE)
	if file:
		file.store_string(JSON.stringify(contents, "\t"))
	else:
		print("File, ", fileName[0] + "/" + fileName[1]," was unable to be edited, returning")
		return
	return fileName

func get_files_in_path(path) -> Array:
	var list = []
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			list.push_back(fileName)
			fileName = dir.get_next()
	
	return list
