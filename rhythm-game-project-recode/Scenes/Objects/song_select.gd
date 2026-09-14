extends PanelContainer

@onready var FileList = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/FileList
var SceneReady = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneReady = true
	FileList.refresh_list()

func _on_visibility_changed() -> void:
	if not SceneReady: return
	FileList.refresh_list()
