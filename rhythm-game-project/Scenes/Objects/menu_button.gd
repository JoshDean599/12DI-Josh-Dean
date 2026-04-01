extends Control

@onready var GameHandler = get_tree().get_root().get_node("GameHandler")

@export var scene = ""
@export var song = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if song != "":
		pass
	if scene != "":
		GameHandler.change_scene(scene)
