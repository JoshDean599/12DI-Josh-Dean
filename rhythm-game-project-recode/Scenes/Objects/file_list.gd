extends PanelContainer

var songButton = preload("res://Scenes/Objects/song_button.tscn")
@onready var list = $PanelContainer/MarginContainer/VBoxContainer
@export var inEditor: bool = false

func add_song(Name: String):
	var newButton = songButton.instantiate()
	newButton.song.text = Name
	newButton.inEditor = inEditor
	list.add_child.call_deferred(newButton)

func clear_list():
	for i in list.get_children():
		i.queue_free()

func load_list(listPath):
	# Maybe change later to load different filePaths
	var dir = DirAccess.open(listPath)
	if dir:
		dir.list_dir_begin()
		var map = dir.get_next()
		while map != "":
			add_song(map)
			map = dir.get_next()

func refresh_list():
	clear_list()
	load_list(get_tree().current_scene.SongMapDirPath)
