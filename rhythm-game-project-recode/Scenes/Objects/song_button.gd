extends PanelContainer

@export var inEditor: bool = false
@export var song: Control
@export var options: Control

func _ready() -> void:
	options.get_popup().connect("index_pressed", _on_options_pressed)

func _on_options_pressed(index) -> void:
	if index == 0:
		OS.move_to_trash(ProjectSettings.globalize_path("user://" + get_tree().current_scene.SongMapPathName + "/" + song.text))
		#DirAccess.remove_absolute("user://" + get_tree().current_scene.SongMapPathName + "/" + song.text)
		#OS.move_to_trash("user://" + get_tree().current_scene.SongMapPathName + "/" + song.text)
		get_parent().get_parent().get_parent().get_parent().refresh_list()
		pass
	pass

func _on_song_pressed() -> void:
	if inEditor:
		pass
	else:
		get_tree().current_scene.load_map(song.text, "Normal")
		get_tree().current_scene.change_scene("Game")
	
