extends Button

@export var target: String
@export var songButton: bool
var difficulty: String = "Normal"

func _on_pressed() -> void:
	if target == "SongSelectMenu" and get_tree().current_scene.get_node("Game").visible:
		get_tree().current_scene.get_node("Game").pause()
	if songButton:
		if get_tree().current_scene.get_node("Editor").visible:
			get_tree().current_scene.get_node("Editor").load_map(text, difficulty)
			return
		else:
			get_tree().current_scene.load_map(text, difficulty)
	get_tree().current_scene.change_scene(target)
