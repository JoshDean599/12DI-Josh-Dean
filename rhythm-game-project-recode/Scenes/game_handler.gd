extends Node2D

@onready var currentScene = $MainMenu
var MapPath = "res://LoadedMaps/"

func _ready() -> void:
	# Make sure everything is hidden, apart from the starting scene
	for i in get_children():
		if i == currentScene:
			i.visible = true
			i.set_process(true)
			continue
		i.visible = false
		i.set_process(false)


func change_scene(scene: String):
	currentScene.set_process(false)
	currentScene.visible = false
	var newScene = get_node(scene)
	newScene.set_process(true)
	newScene.visible = true
	currentScene = newScene
