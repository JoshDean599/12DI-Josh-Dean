extends Button

@export var target: String
var difficulty: String = "Normal"

func _on_pressed() -> void:
	if target == "SongSelectMenu" and get_tree().current_scene.get_node("Game").visible:
		get_tree().current_scene.get_node("Game").pause()
	get_tree().current_scene.change_scene(target)
