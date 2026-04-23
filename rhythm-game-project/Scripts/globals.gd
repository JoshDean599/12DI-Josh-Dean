extends Node

# File Locations
var MainMenu  = preload("res://Scenes/main_menu.tscn").instantiate()
var Game   = preload("res://Scenes/game.tscn").instantiate()
var Editor = preload("res://Scenes/editor.tscn").instantiate()

# Notes
var GameNote = preload("res://Scenes/Objects/game_note.tscn")
var EditorNote = preload("res://Scenes/Objects/editor_note.tscn")

func change_scene(node):
	var tree = get_tree()
	var currentScene = tree.current_scene
	tree.root.remove_child(currentScene) # Remove the old scene
	tree.root.add_child(node) # Add the new scene
	tree.current_scene = node # Set the new scene to the current
