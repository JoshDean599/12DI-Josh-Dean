extends Node

@warning_ignore("unused_signal")
signal IncrimentScore(incr: int)

@export var BASEPATH = "res://SongMaps/"
var song = ""

var currentScene = "MainMenu"
var previousScene = ""

func change_scene(newScene: String):
	if get_node(newScene):
		previousScene = currentScene
		get_node(currentScene).visible = false
		get_node(newScene).visible = true
		currentScene = newScene
	else:
		print("Unable to find the new Scene, ignoring")
