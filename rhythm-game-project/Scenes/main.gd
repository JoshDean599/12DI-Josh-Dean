extends Node

var Menus  = preload("res://Scenes/node_2d.tscn").instantiate()
var Game   = preload("res://Scenes/game.tscn").instantiate()
var Editor = preload("res://Scenes/UI/editor.tscn").instantiate()
# FIX these files ;-;

func change_scene(node):
	var tree = get_tree()
	var currentScene = tree.current_scene
	tree.root.add_child(node)
	tree.root.remove_child(currentScene)
	tree.current_scene = node
