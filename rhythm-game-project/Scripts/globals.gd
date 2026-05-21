extends Node

# Scenes
var MainMenu  = preload("res://Scenes/main_menu.tscn").instantiate()
var Game      = preload("res://Scenes/game.tscn").instantiate()
var Editor    = preload("res://Scenes/editor.tscn").instantiate()

# Notes
var GameNote   = preload("res://Scenes/Objects/game_note.tscn")
var EditorNote = preload("res://Scenes/Objects/editor_note.tscn")

# The Song File base location
var mapPath = "res://Songs/Maps/"
var musicPath = "res://Songs/Music/"


func change_scene(node):
	var tree = get_tree()
	var currentScene = tree.current_scene
	tree.root.remove_child(currentScene) # Remove the old scene
	tree.root.add_child(node) # Add the new scene
	tree.current_scene = node # Set the new scene to the current

func load_song(path) -> Dictionary:
	if not FileAccess.open(path, FileAccess.READ):
		return {}
	
	var saveString = FileAccess.get_file_as_string(path)
	return JSON.parse_string(saveString)

# Score definitions. CHANGE TO SOMEWHERE BETTER THAN HERE
var scores = {
	ok = {
		lower = -.5,
		upper = .5,
		score = 50
	},
	perfect = {
		lower = -.1,
		upper = .1,
		score = 200
	}
}
