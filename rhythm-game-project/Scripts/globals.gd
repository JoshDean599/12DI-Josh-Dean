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

# EditorGrid:
const editorGrid = Vector2(100, 100)
const editorSnappingKey = KEY_SPACE
var editorGridLockKeyPress: bool = false

# Note variables:
var noteMoveSpeed = 250.0

# GameVariables
var loadedSong := "new"
var gameTime := 0.0
var gameBufferTime := 0.5
var gameScore := 0
var gamePlaying := false


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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == editorSnappingKey:
			editorGridLockKeyPress = event.pressed
