extends Node

@warning_ignore("unused_signal")
signal IncrimentScore(incr: int)

@export var BASEPATH = "res://SongMaps/"
var song = ""

var currentScene = "UI/MainMenu"

func change_scene(newScene: String):
	if get_node(newScene):
		get_node(currentScene).visible = false
		get_node(newScene).visible = true
		currentScene = newScene
	else:
		print("Unable to find the new Scene, ignoring")


func _on_editor_visibility_changed() -> void:
	if $Editor.visible:
		$UI/EditorUI.visible = true
	else:
		$UI/EditorUI.visible = false
