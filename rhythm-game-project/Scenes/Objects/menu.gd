extends Control

@onready var GameHandler = get_tree().get_root().get_node("GameHandler")

var override = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.get_class() == "Button":
			if child.get_node("Override"):
				override = child.get_node("Override").text
				child.pressed.connect(_override_button_press)
				continue
			
			if child.text == "Back":
				child.pressed.connect(_back_button_press)
			
			pass
		print(child.get_class())
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _back_button_press():
	if GameHandler.previousScene != "":
		print(GameHandler.previousScene)
		GameHandler.change_scene(GameHandler.previousScene)

func _override_button_press():
	GameHandler.change_scene(override)
	print(override)
