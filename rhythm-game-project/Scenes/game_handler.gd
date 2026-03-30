extends Node

@warning_ignore("unused_signal")
signal IncrimentScore(incr: int)


@export var BASEPATH = "res://SongMaps/"
var song = ""

func change_scene(sceneName: String, newSceneName: String):
	if get_node(sceneName):
		get_node(sceneName).visible = false
	else:
		print("Unable to find the current scene, ignoring")
	if get_node(newSceneName):
		get_node(newSceneName).visible = true
	else:
		print("Unable to find the new Scene, ignoring")
