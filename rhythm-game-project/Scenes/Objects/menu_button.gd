extends Control

@onready var GameHandler = get_tree().get_root().get_node("GameHandler")

@export var scene = ""
@export var song = ""

func _on_pressed() -> void:
	if song != "":
		pass
	if scene != "":
		Main.change_scene(Main.Menus)
