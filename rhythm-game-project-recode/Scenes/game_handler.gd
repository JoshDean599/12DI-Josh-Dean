extends Node2D

@onready var currentScene = $MainMenu
const MapPath = "res://LoadedMaps/"

var noteMoveSpeed = 250 # Pixels a second
var YCollumnHeight = 10

func _ready() -> void:
	# Make sure everything is hidden, apart from the starting scene
	for i in get_children():
		if i == currentScene:
			set_scene_visible(i, true)
			continue
		set_scene_visible(i, false)


func change_scene(scene: String):
	set_scene_visible(currentScene, false)
	var newScene = get_node(scene)
	set_scene_visible(newScene, true)
	currentScene = newScene

func set_scene_visible(scene, type: bool) -> void:
	scene.visible = type
	if scene.find_child("CanvasLayer"):
		scene.get_node("CanvasLayer").visible = type
	scene.set_process(type)
