extends HBoxContainer

@export var inEditor: bool = false
@export var song: Control
@export var options: Control

func _ready() -> void:
	options.get_popup().connect("index_pressed", _on_options_pressed)

func _on_options_pressed(index) -> void:
	if index == 0:
		OS.move_to_trash(ProjectSettings.globalize_path(get_tree().current_scene.SongMapDirPath + "/" + song.text))
		get_parent().get_parent().get_parent().get_parent().refresh_list()
