extends Button

@export var target: String
@export var songButton: bool

func _on_pressed() -> void:
	if target == "SongSelectMenu" and get_tree().current_scene.get_node("Game").visible:
		get_tree().current_scene.get_node("Game").pause()
	if songButton:
		if get_tree().current_scene.get_node("Editor").visible:
			return
		else:
			get_tree().current_scene.load_map(text, "Normal")
	get_tree().current_scene.change_scene(target)
