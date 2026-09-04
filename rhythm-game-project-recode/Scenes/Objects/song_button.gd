extends PanelContainer

@export var inEditor: bool = false
@export var song: Control
@export var options: Control

func _ready() -> void:
	$HBoxContainer/MenuButton.get_popup().connect("index_pressed", _on_options_pressed)

func _on_options_pressed() -> void:
	pass

func _on_song_pressed() -> void:
	if inEditor:
		pass
	else:
		pass
	
