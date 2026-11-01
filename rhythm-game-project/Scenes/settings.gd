extends Node2D

func _ready() -> void:
	$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/SpinBox.value = GameData.NoteSpeed

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_spin_box_value_changed(value: float) -> void:
	GameData.NoteSpeed = value

func _process(delta: float) -> void:
	$Sprite2D.position.x = posmod(-GameData.NoteSpeed * delta + ($Sprite2D.position.x + $Sprite2D.texture.get_width() / 2),
		DisplayServer.window_get_size().x + $Sprite2D.texture.get_width()) - $Sprite2D.texture.get_width() / 2
