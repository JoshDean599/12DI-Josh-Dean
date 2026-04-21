extends Node

@warning_ignore("unused_signal")
signal IncrimentScore(incr: int)

@export var BASEPATH = "res://SongMaps/"
var song = ""

var currentScene = "MainMenu"

func change_scene(newScene: String):
	if get_node(newScene):
		if not $Camera2D.is_current():
			$Camera2D.make_current()
		
		get_node(currentScene).visible = false
		get_node(newScene).visible = true
		currentScene = newScene
		
	else:
		print("Unable to find the new Scene, ignoring")
