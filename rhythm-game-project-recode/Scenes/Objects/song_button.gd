extends Button

@onready var SongSelectMenu = get_tree().current_scene.get_node("SongSelectMenu")

func _on_pressed() -> void:
	SongSelectMenu.SongButtonSelected(self.text)
	pass # Replace with function body.
